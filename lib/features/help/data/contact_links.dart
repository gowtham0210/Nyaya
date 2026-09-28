/// A `tel:` link for [number], keeping only digits and `+`.
Uri telLink(String number) =>
    Uri(scheme: 'tel', path: number.replaceAll(RegExp(r'[^0-9+]'), ''));

Uri mailLink(String email) => Uri(scheme: 'mailto', path: email);
