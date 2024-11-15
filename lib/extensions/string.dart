extension StringExtension on String {
  String slugify() {
    // Step 1: Remove Vietnamese accents
    const vietnameseAccents = {
      'a': 'àáạảãâầấậẩẫăằắặẳẵ',
      'e': 'èéẹẻẽêềếệểễ',
      'i': 'ìíịỉĩ',
      'o': 'òóọỏõôồốộổỗơờớợởỡ',
      'u': 'ùúụủũưừứựửữ',
      'y': 'ỳýỵỷỹ',
      'd': 'đ',
      'A': 'ÀÁẠẢÃÂẦẤẬẨẪĂẰẮẶẲẴ',
      'E': 'ÈÉẸẺẼÊỀẾỆỂỄ',
      'I': 'ÌÍỊỈĨ',
      'O': 'ÒÓỌỎÕÔỒỐỘỔỖƠỜỚỢỞỠ',
      'U': 'ÙÚỤỦŨƯỪỨỰỬỮ',
      'Y': 'ỲÝỴỶỸ',
      'D': 'Đ'
    };

    String text = this;

    vietnameseAccents.forEach((nonAccent, accents) {
      for (var accent in accents.split('')) {
        text = text.replaceAll(accent, nonAccent);
      }
    });

    // Step 2: Convert to lowercase
    text = text.toLowerCase();

    // Step 3: Replace spaces and special characters with hyphens
    text = text.replaceAll(RegExp(r'[^a-z0-9]+'), '-');

    // Step 4: Remove any leading/trailing hyphens and consecutive hyphens
    text = text.replaceAll(RegExp(r'-+'), '-').replaceAll(RegExp(r'^-|-$'), '');

    return text;
  }
}
