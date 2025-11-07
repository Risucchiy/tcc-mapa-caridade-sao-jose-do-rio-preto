import 'package:cloud_firestore/cloud_firestore.dart';

class Instituicao {
  final String id;
  final String nome;
  final String cnpj;
  final String descricaoCurta;
  final String descricaoCompleta;
  final GeoPoint localizacao;
  final Map<String, dynamic> endereco;
  final String telefone;
  final String email;
  final List<String> categorias;
  final String urlLogo;
  final List<String> urlFotos;
  final List<Map<String, dynamic>> necessidadesAtuais;
  final bool ativa;

  Instituicao({
    required this.id,
    required this.nome,
    required this.cnpj,
    required this.descricaoCurta,
    required this.descricaoCompleta,
    required this.localizacao,
    required this.endereco,
    required this.telefone,
    required this.email,
    required this.categorias,
    required this.urlLogo,
    required this.urlFotos,
    required this.necessidadesAtuais,
    required this.ativa,
  });

  factory Instituicao.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Instituicao(
      id: doc.id,
      nome: data['nome'] ?? 'Nome não disponível',
      cnpj: data['cnpj'] ?? 'CNPJ não disponível',
      descricaoCurta: data['descricaoCurta'] ?? '',
      descricaoCompleta: data['descricaoCompleta'] ?? 'Descrição não disponível.',
      localizacao: data['localizacao'] ?? const GeoPoint(0, 0),
      endereco: data['endereco'] ?? {},
      telefone: data['telefone'] ?? 'Não informado',
      email: data['email'] ?? 'Não informado',
      categorias: List<String>.from(data['categorias'] ?? []),
      urlLogo: data['urlLogo'] ?? '',
      urlFotos: List<String>.from(data['urlFotos'] ?? []),
      necessidadesAtuais: List<Map<String, dynamic>>.from(data['necessidadesAtuais'] ?? []),
      ativa: data['ativa'] ?? true,
    );
  }
}