import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/instituicao_model.dart';
import '../services/favorites_service.dart';
import 'detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FavoritesService _favoritesService = FavoritesService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Instituicao>> _fetchFavoriteInstitutions() async {
    final favoriteIds = await _favoritesService.getFavorites();

    if (favoriteIds.isEmpty) {
      return [];
    }

    final querySnapshot = await _firestore
        .collection('instituicoes')
        .where(FieldPath.documentId, whereIn: favoriteIds)
        .get();
    
    return querySnapshot.docs.map((doc) => Instituicao.fromFirestore(doc)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Instituições Favoritas'),
      ),
      body: FutureBuilder<List<Instituicao>>(
        future: _fetchFavoriteInstitutions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar favoritos: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Você ainda não adicionou nenhuma instituição aos favoritos.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          final favoriteInstitutions = snapshot.data!;

          return ListView.builder(
            itemCount: favoriteInstitutions.length,
            itemBuilder: (context, index) {
              final instituicao = favoriteInstitutions[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: instituicao.urlLogo.isNotEmpty ? NetworkImage(instituicao.urlLogo) : null,
                    child: instituicao.urlLogo.isEmpty ? const Icon(Icons.business) : null,
                  ),
                  title: Text(instituicao.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(instituicao.descricaoCurta),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DetailScreen(instituicao: instituicao)),
                    ).then((_) {
                      setState(() {});
                    });
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}