import 'package:flutter/material.dart';
import '../../domain/entities/memory_location.dart';

class ManualLocationForm extends StatefulWidget {
  const ManualLocationForm({
    super.key,
    required this.onSaveLocation,
    this.initialLocation,
  });

  final ValueChanged<MemoryLocation> onSaveLocation;
  final MemoryLocation? initialLocation;

  @override
  State<ManualLocationForm> createState() => _ManualLocationFormState();
}

class _ManualLocationFormState extends State<ManualLocationForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _addressController;
  late final TextEditingController _latController;
  late final TextEditingController _lonController;

  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _titleColor = Color(0xFF38251F);

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.initialLocation?.name ?? '');
    _addressController =
        TextEditingController(text: widget.initialLocation?.address ?? '');
    _latController = TextEditingController(
      text: widget.initialLocation?.latitude?.toString() ?? '',
    );
    _lonController = TextEditingController(
      text: widget.initialLocation?.longitude?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _latController.dispose();
    _lonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: const Color(0xFFEADBCE), width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter Location Manually',
              style: TextStyle(
                color: _titleColor,
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16.0),

            // Place Name (Required)
            _buildTextField(
              label: 'Place Name *',
              hint: 'e.g. Marina Beach, Central Park',
              controller: _nameController,
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Please enter a place name.';
                }
                return null;
              },
            ),
            const SizedBox(height: 12.0),

            // Address (Optional)
            _buildTextField(
              label: 'Address (Optional)',
              hint: 'City, Region or Country',
              controller: _addressController,
            ),
            const SizedBox(height: 12.0),

            // Coordinates Row (Optional)
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    label: 'Latitude (-90 to 90)',
                    hint: 'e.g. 13.0827',
                    controller: _latController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true, signed: true),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) return null;
                      final n = double.tryParse(val.trim());
                      if (n == null || n < -90.0 || n > 90.0) {
                        return 'Between -90 & 90';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: _buildTextField(
                    label: 'Longitude (-180 to 180)',
                    hint: 'e.g. 80.2707',
                    controller: _lonController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true, signed: true),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) return null;
                      final n = double.tryParse(val.trim());
                      if (n == null || n < -180.0 || n > 180.0) {
                        return 'Between -180 & 180';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18.0),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 46.0,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryOrange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                onPressed: _submit,
                child: const Text(
                  'Set Manual Location',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    FormFieldValidator<String>? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: _titleColor,
          ),
        ),
        const SizedBox(height: 6.0),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(fontSize: 14.0, color: _titleColor),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFFB0A29A), fontSize: 13.0),
            filled: true,
            fillColor: const Color(0xFFFFF8F1),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: Color(0xFFEADBCE), width: 0.8),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: Color(0xFFEADBCE), width: 0.8),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: _primaryOrange, width: 1.4),
            ),
          ),
        ),
      ],
    );
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text.trim();
      final address = _addressController.text.trim().isEmpty
          ? null
          : _addressController.text.trim();
      final lat = double.tryParse(_latController.text.trim());
      final lon = double.tryParse(_lonController.text.trim());

      final location = MemoryLocation(
        name: name,
        address: address,
        latitude: lat,
        longitude: lon,
        source: 'manual',
        createdAt: DateTime.now().toUtc(),
      );

      widget.onSaveLocation(location);
    }
  }
}

