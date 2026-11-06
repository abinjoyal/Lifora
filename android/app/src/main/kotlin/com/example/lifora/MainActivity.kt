package com.example.lifora

import android.Manifest
import android.app.Activity
import android.content.ContentUris
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.provider.MediaStore
import androidx.core.content.ContextCompat
import androidx.core.content.FileProvider
import androidx.documentfile.provider.DocumentFile
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream
import java.io.File

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.lifora.app/saf"
    private val PHOTO_CHANNEL = "com.lifora.app/photos"
    private val REQUEST_CODE_SAF = 1042
    private val REQUEST_CODE_PHOTO_PICKER = 1043
    private val REQUEST_CODE_CAMERA = 1044

    private var pendingSafResult: MethodChannel.Result? = null
    private var pendingPhotoPickerResult: MethodChannel.Result? = null
    private var pendingCameraResult: MethodChannel.Result? = null
    private var currentCameraPhotoPath: String? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // 1. SAF Storage Channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "openDocumentTree" -> {
                    if (pendingSafResult != null) {
                        result.error("BUSY", "A folder selection is already in progress.", null)
                        return@setMethodCallHandler
                    }
                    pendingSafResult = result
                    val intent = Intent(Intent.ACTION_OPEN_DOCUMENT_TREE).apply {
                        addFlags(
                            Intent.FLAG_GRANT_READ_URI_PERMISSION or
                            Intent.FLAG_GRANT_WRITE_URI_PERMISSION or
                            Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION or
                            Intent.FLAG_GRANT_PREFIX_URI_PERMISSION
                        )
                    }
                    try {
                        startActivityForResult(intent, REQUEST_CODE_SAF)
                    } catch (e: Exception) {
                        pendingSafResult = null
                        result.error("ACTIVITY_NOT_FOUND", "SAF activity could not be launched.", e.message)
                    }
                }

                "takePersistableUriPermission" -> {
                    val uriString = call.argument<String>("uri")
                    if (uriString == null) {
                        result.error("INVALID_ARG", "URI cannot be null.", null)
                        return@setMethodCallHandler
                    }
                    try {
                        val uri = Uri.parse(uriString)
                        val takeFlags = Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION
                        contentResolver.takePersistableUriPermission(uri, takeFlags)
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("PERMISSION_FAILED", e.message, null)
                    }
                }

                "hasUriPermission" -> {
                    val uriString = call.argument<String>("uri")
                    if (uriString == null) {
                        result.success(false)
                        return@setMethodCallHandler
                    }
                    try {
                        val targetUri = Uri.parse(uriString)
                        val persisted = contentResolver.persistedUriPermissions
                        val hasPermission = persisted.any {
                            it.uri == targetUri && it.isReadPermission && it.isWritePermission
                        }
                        result.success(hasPermission)
                    } catch (e: Exception) {
                        result.success(false)
                    }
                }

                "releasePersistableUriPermission" -> {
                    val uriString = call.argument<String>("uri")
                    if (uriString == null) {
                        result.error("INVALID_ARG", "URI cannot be null.", null)
                        return@setMethodCallHandler
                    }
                    try {
                        val uri = Uri.parse(uriString)
                        val flags = Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION
                        contentResolver.releasePersistableUriPermission(uri, flags)
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("RELEASE_FAILED", e.message, null)
                    }
                }

                "checkFolderAccess" -> {
                    val uriString = call.argument<String>("uri")
                    if (uriString == null) {
                        result.error("INVALID_ARG", "URI cannot be null.", null)
                        return@setMethodCallHandler
                    }
                    try {
                        val uri = Uri.parse(uriString)
                        val doc = DocumentFile.fromTreeUri(applicationContext, uri)
                        if (doc == null || !doc.exists()) {
                            result.success(mapOf("exists" to false, "canRead" to false, "canWrite" to false))
                            return@setMethodCallHandler
                        }
                        result.success(mapOf("exists" to true, "canRead" to doc.canRead(), "canWrite" to doc.canWrite()))
                    } catch (e: Exception) {
                        result.error("CHECK_FAILED", e.message, null)
                    }
                }

                "createDirectory" -> {
                    val parentUriString = call.argument<String>("parentUri")
                    val dirName = call.argument<String>("name")
                    if (parentUriString == null || dirName == null) {
                        result.error("INVALID_ARG", "parentUri and name are required.", null)
                        return@setMethodCallHandler
                    }
                    try {
                        val parentUri = Uri.parse(parentUriString)
                        val parentDoc = DocumentFile.fromTreeUri(applicationContext, parentUri)
                        if (parentDoc == null || !parentDoc.exists()) {
                            result.error("PARENT_NOT_FOUND", "Parent folder does not exist: $parentUriString", null)
                            return@setMethodCallHandler
                        }
                        val existing = parentDoc.findFile(dirName)
                        if (existing != null && existing.isDirectory) {
                            result.success(existing.uri.toString())
                            return@setMethodCallHandler
                        }
                        val created = parentDoc.createDirectory(dirName)
                        if (created != null) {
                            result.success(created.uri.toString())
                        } else {
                            result.error("CREATE_FAILED", "Failed to create directory $dirName", null)
                        }
                    } catch (e: Exception) {
                        result.error("CREATE_FAILED", e.message, null)
                    }
                }

                "createFile" -> {
                    val parentUriString = call.argument<String>("parentUri")
                    val name = call.argument<String>("name")
                    val mimeType = call.argument<String>("mimeType") ?: "application/octet-stream"
                    val bytes = call.argument<ByteArray>("bytes")

                    if (parentUriString == null || name == null) {
                        result.error("INVALID_ARG", "parentUri and name are required.", null)
                        return@setMethodCallHandler
                    }
                    try {
                        val parentUri = Uri.parse(parentUriString)
                        val parentDoc = DocumentFile.fromTreeUri(applicationContext, parentUri)
                        if (parentDoc == null || !parentDoc.exists()) {
                            result.error("PARENT_NOT_FOUND", "Parent folder does not exist.", null)
                            return@setMethodCallHandler
                        }
                        val existing = parentDoc.findFile(name)
                        existing?.delete()

                        val created = parentDoc.createFile(mimeType, name)
                        if (created == null) {
                            result.error("CREATE_FAILED", "Failed to create file $name", null)
                            return@setMethodCallHandler
                        }
                        if (bytes != null && bytes.isNotEmpty()) {
                            contentResolver.openOutputStream(created.uri, "wt")?.use { stream ->
                                stream.write(bytes)
                                stream.flush()
                            }
                        }
                        result.success(created.uri.toString())
                    } catch (e: Exception) {
                        result.error("CREATE_FAILED", e.message, null)
                    }
                }

                "writeBytesToUri" -> {
                    val uriString = call.argument<String>("uri")
                    val bytes = call.argument<ByteArray>("bytes")
                    if (uriString == null || bytes == null) {
                        result.error("INVALID_ARG", "uri and bytes are required.", null)
                        return@setMethodCallHandler
                    }
                    try {
                        val uri = Uri.parse(uriString)
                        contentResolver.openOutputStream(uri, "wt")?.use { stream ->
                            stream.write(bytes)
                            stream.flush()
                        }
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("WRITE_FAILED", e.message, null)
                    }
                }

                "readBytesFromUri" -> {
                    val uriString = call.argument<String>("uri")
                    if (uriString == null) {
                        result.error("INVALID_ARG", "uri is required.", null)
                        return@setMethodCallHandler
                    }
                    try {
                        val uri = Uri.parse(uriString)
                        contentResolver.openInputStream(uri)?.use { stream ->
                            val buffer = ByteArrayOutputStream()
                            val data = ByteArray(4096)
                            var count: Int
                            while (stream.read(data, 0, data.size).also { count = it } != -1) {
                                buffer.write(data, 0, count)
                            }
                            result.success(buffer.toByteArray())
                        } ?: result.error("READ_FAILED", "Could not open stream for $uriString.", null)
                    } catch (e: Exception) {
                        result.error("READ_FAILED", e.message, null)
                    }
                }

                "listFiles" -> {
                    val folderUriString = call.argument<String>("folderUri")
                    if (folderUriString == null) {
                        result.error("INVALID_ARG", "folderUri is required.", null)
                        return@setMethodCallHandler
                    }
                    try {
                        val folderUri = Uri.parse(folderUriString)
                        val folderDoc = DocumentFile.fromTreeUri(applicationContext, folderUri)
                        if (folderDoc == null || !folderDoc.exists()) {
                            result.success(emptyList<Map<String, Any>>())
                            return@setMethodCallHandler
                        }

                        val fileList = folderDoc.listFiles().map { doc ->
                            mapOf(
                                "name" to (doc.name ?: ""),
                                "uri" to doc.uri.toString(),
                                "isDirectory" to doc.isDirectory,
                                "size" to doc.length(),
                                "lastModified" to doc.lastModified()
                            )
                        }
                        result.success(fileList)
                    } catch (e: Exception) {
                        result.error("LIST_FAILED", e.message, null)
                    }
                }

                else -> result.notImplemented()
            }
        }

        // 2. Photos Channel (Android Photo Picker, Gallery MediaStore & Camera)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, PHOTO_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "checkPhotoPermission" -> {
                    val permission = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                        Manifest.permission.READ_MEDIA_IMAGES
                    } else {
                        Manifest.permission.READ_EXTERNAL_STORAGE
                    }
                    val isGranted = ContextCompat.checkSelfPermission(this, permission) == PackageManager.PERMISSION_GRANTED
                    result.success(isGranted)
                }

                "getPhotoAlbums" -> {
                    try {
                        val albums = queryPhotoAlbums()
                        result.success(albums)
                    } catch (e: Exception) {
                        result.error("QUERY_FAILED", e.message, null)
                    }
                }

                "getGalleryPhotos" -> {
                    val albumId = call.argument<String>("albumId")
                    val limit = call.argument<Int>("limit") ?: 300
                    try {
                        val photos = queryGalleryPhotos(albumId, limit)
                        result.success(photos)
                    } catch (e: Exception) {
                        result.error("QUERY_FAILED", e.message, null)
                    }
                }

                "openPhotoPicker" -> {
                    if (pendingPhotoPickerResult != null) {
                        result.error("BUSY", "Photo picker is already open.", null)
                        return@setMethodCallHandler
                    }
                    pendingPhotoPickerResult = result

                    val intent = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                        Intent(MediaStore.ACTION_PICK_IMAGES).apply {
                            putExtra(MediaStore.EXTRA_PICK_IMAGES_MAX, 30)
                        }
                    } else {
                        Intent(Intent.ACTION_GET_CONTENT).apply {
                            type = "image/*"
                            putExtra(Intent.EXTRA_ALLOW_MULTIPLE, true)
                        }
                    }

                    try {
                        startActivityForResult(intent, REQUEST_CODE_PHOTO_PICKER)
                    } catch (e: Exception) {
                        pendingPhotoPickerResult = null
                        result.error("LAUNCH_FAILED", e.message, null)
                    }
                }

                "capturePhoto" -> {
                    if (pendingCameraResult != null) {
                        result.error("BUSY", "Camera is already active.", null)
                        return@setMethodCallHandler
                    }
                    pendingCameraResult = result

                    try {
                        val photoFile = File(cacheDir, "camera_capture_${System.currentTimeMillis()}.jpg")
                        currentCameraPhotoPath = photoFile.absolutePath

                        val photoUri: Uri = FileProvider.getUriForFile(
                            this,
                            "${applicationContext.packageName}.fileprovider",
                            photoFile
                        )

                        val intent = Intent(MediaStore.ACTION_IMAGE_CAPTURE).apply {
                            putExtra(MediaStore.EXTRA_OUTPUT, photoUri)
                            addFlags(Intent.FLAG_GRANT_WRITE_URI_PERMISSION or Intent.FLAG_GRANT_READ_URI_PERMISSION)
                        }

                        startActivityForResult(intent, REQUEST_CODE_CAMERA)
                    } catch (e: Exception) {
                        pendingCameraResult = null
                        currentCameraPhotoPath = null
                        result.error("CAMERA_LAUNCH_FAILED", e.message, null)
                    }
                }

                else -> result.notImplemented()
            }
        }
    }

    private fun queryPhotoAlbums(): List<Map<String, Any>> {
        val albums = mutableMapOf<String, MutableMap<String, Any>>()
        val projection = arrayOf(
            MediaStore.Images.Media.BUCKET_ID,
            MediaStore.Images.Media.BUCKET_DISPLAY_NAME,
            MediaStore.Images.Media._ID,
            MediaStore.Images.Media.DATA
        )

        val sortOrder = "${MediaStore.Images.Media.DATE_ADDED} DESC"
        contentResolver.query(
            MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
            projection,
            null,
            null,
            sortOrder
        )?.use { cursor ->
            val bucketIdCol = cursor.getColumnIndex(MediaStore.Images.Media.BUCKET_ID)
            val bucketNameCol = cursor.getColumnIndex(MediaStore.Images.Media.BUCKET_DISPLAY_NAME)
            val idCol = cursor.getColumnIndex(MediaStore.Images.Media._ID)
            val dataCol = cursor.getColumnIndex(MediaStore.Images.Media.DATA)

            while (cursor.moveToNext()) {
                val bucketId = cursor.getString(bucketIdCol) ?: "unknown"
                val bucketName = cursor.getString(bucketNameCol) ?: "Gallery"
                val id = cursor.getLong(idCol)
                val path = cursor.getString(dataCol) ?: ContentUris.withAppendedId(
                    MediaStore.Images.Media.EXTERNAL_CONTENT_URI, id
                ).toString()

                if (!albums.containsKey(bucketId)) {
                    albums[bucketId] = mutableMapOf(
                        "id" to bucketId,
                        "name" to bucketName,
                        "photoCount" to 1,
                        "coverPhotoPath" to path
                    )
                } else {
                    val count = (albums[bucketId]?.get("photoCount") as? Int) ?: 0
                    albums[bucketId]?.put("photoCount", count + 1)
                }
            }
        }
        return albums.values.toList()
    }

    private fun queryGalleryPhotos(albumId: String?, limit: Int): List<Map<String, Any>> {
        val photos = mutableListOf<Map<String, Any>>()
        val projection = arrayOf(
            MediaStore.Images.Media._ID,
            MediaStore.Images.Media.DISPLAY_NAME,
            MediaStore.Images.Media.DATA,
            MediaStore.Images.Media.DATE_ADDED,
            MediaStore.Images.Media.SIZE,
            MediaStore.Images.Media.MIME_TYPE,
            MediaStore.Images.Media.WIDTH,
            MediaStore.Images.Media.HEIGHT,
            MediaStore.Images.Media.BUCKET_ID,
            MediaStore.Images.Media.BUCKET_DISPLAY_NAME
        )

        var selection: String? = null
        var selectionArgs: Array<String>? = null
        if (albumId != null && albumId.isNotEmpty() && albumId != "all") {
            selection = "${MediaStore.Images.Media.BUCKET_ID} = ?"
            selectionArgs = arrayOf(albumId)
        }

        val sortOrder = "${MediaStore.Images.Media.DATE_ADDED} DESC LIMIT $limit"
        contentResolver.query(
            MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
            projection,
            selection,
            selectionArgs,
            sortOrder
        )?.use { cursor ->
            val idCol = cursor.getColumnIndex(MediaStore.Images.Media._ID)
            val nameCol = cursor.getColumnIndex(MediaStore.Images.Media.DISPLAY_NAME)
            val dataCol = cursor.getColumnIndex(MediaStore.Images.Media.DATA)
            val dateCol = cursor.getColumnIndex(MediaStore.Images.Media.DATE_ADDED)
            val sizeCol = cursor.getColumnIndex(MediaStore.Images.Media.SIZE)
            val mimeCol = cursor.getColumnIndex(MediaStore.Images.Media.MIME_TYPE)
            val widthCol = cursor.getColumnIndex(MediaStore.Images.Media.WIDTH)
            val heightCol = cursor.getColumnIndex(MediaStore.Images.Media.HEIGHT)
            val bIdCol = cursor.getColumnIndex(MediaStore.Images.Media.BUCKET_ID)
            val bNameCol = cursor.getColumnIndex(MediaStore.Images.Media.BUCKET_DISPLAY_NAME)

            while (cursor.moveToNext()) {
                val id = cursor.getLong(idCol)
                val path = cursor.getString(dataCol) ?: ContentUris.withAppendedId(
                    MediaStore.Images.Media.EXTERNAL_CONTENT_URI, id
                ).toString()

                photos.add(
                    mapOf(
                        "id" to id.toString(),
                        "name" to (cursor.getString(nameCol) ?: "photo_$id.jpg"),
                        "path" to path,
                        "dateAdded" to (cursor.getLong(dateCol) * 1000L),
                        "size" to cursor.getLong(sizeCol),
                        "mimeType" to (cursor.getString(mimeCol) ?: "image/jpeg"),
                        "width" to cursor.getInt(widthCol),
                        "height" to cursor.getInt(heightCol),
                        "albumId" to (cursor.getString(bIdCol) ?: ""),
                        "albumName" to (cursor.getString(bNameCol) ?: "Gallery")
                    )
                )
            }
        }
        return photos
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        when (requestCode) {
            REQUEST_CODE_SAF -> {
                val pending = pendingSafResult
                pendingSafResult = null

                if (resultCode == Activity.RESULT_OK && data != null && data.data != null) {
                    val treeUri = data.data!!
                    try {
                        val takeFlags = Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION
                        contentResolver.takePersistableUriPermission(treeUri, takeFlags)
                        pending?.success(treeUri.toString())
                    } catch (e: Exception) {
                        pending?.success(treeUri.toString())
                    }
                } else {
                    pending?.success(null)
                }
            }

            REQUEST_CODE_PHOTO_PICKER -> {
                val pending = pendingPhotoPickerResult
                pendingPhotoPickerResult = null

                if (resultCode == Activity.RESULT_OK && data != null) {
                    val paths = mutableListOf<String>()
                    val clipData = data.clipData
                    if (clipData != null) {
                        for (i in 0 until clipData.itemCount) {
                            paths.add(clipData.getItemAt(i).uri.toString())
                        }
                    } else if (data.data != null) {
                        paths.add(data.data!!.toString())
                    }
                    pending?.success(paths)
                } else {
                    pending?.success(emptyList<String>())
                }
            }

            REQUEST_CODE_CAMERA -> {
                val pending = pendingCameraResult
                pendingCameraResult = null
                val path = currentCameraPhotoPath
                currentCameraPhotoPath = null

                if (resultCode == Activity.RESULT_OK && path != null && File(path).exists()) {
                    pending?.success(path)
                } else {
                    pending?.success(null)
                }
            }
        }
    }
}
