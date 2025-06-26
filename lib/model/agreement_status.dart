

class AgreementStatus {
  final bool agreedRequiredTerms;
  final List<AgreementTerm> terms;

  AgreementStatus({
    required this.agreedRequiredTerms,
    required this.terms,
  });

  static AgreementStatus fromJson(params) {
    bool agreedRequiredTerms = params['agreedRequiredTerms'];

    List<AgreementTerm> terms = [];
    for (var term in params['terms']) {
      String id = term['id'];
      bool agreed = term['agreed'];
      bool required = term['required'];

      terms.add(AgreementTerm(id: id, agreed: agreed, required: required));
    }
    return AgreementStatus(
        agreedRequiredTerms: agreedRequiredTerms, terms: terms);
  }

  @override
  String toString() {
    return '$agreedRequiredTerms\n ${terms.map((term) => term.toString()).join('\n')}';
  }
}

class AgreementTerm {
  final String id;
  final bool agreed;
  final bool required;

  AgreementTerm({required this.id, this.agreed = false, this.required = false});

  @override
  String toString() {
    return 'agreed : $agreed, required: $required';
  }
}
