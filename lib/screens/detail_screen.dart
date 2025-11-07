import 'package:flutter/material.dart';
import '../models/instituicao_model.dart';
import '../services/favorites_service.dart';

class DetailScreen extends StatefulWidget {
  final Instituicao instituicao;
  const DetailScreen({super.key, required this.instituicao});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final FavoritesService _favoritesService = FavoritesService();
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    final isFav = await _favoritesService.isFavorite(widget.instituicao.id);
    if (mounted) {
      setState(() {
        _isFavorite = isFav;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    if (_isFavorite) {
      await _favoritesService.removeFavorite(widget.instituicao.id);
    } else {
      await _favoritesService.addFavorite(widget.instituicao.id);
    }
    _checkIfFavorite();
  }

  Widget _buildInfoRow(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).primaryColor, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final instituicao = widget.instituicao;
    final String enderecoCompleto =
        '${instituicao.endereco['rua'] ?? ''}, ${instituicao.endereco['numero'] ?? ''}\n'
        '${instituicao.endereco['bairro'] ?? ''} - ${instituicao.endereco['cidade'] ?? ''}';

    return Scaffold(
      appBar: AppBar(
        title: Text(instituicao.nome),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.redAccent : Colors.white,
            ),
            onPressed: _toggleFavorite,
            tooltip: 'Favoritar',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  if (instituicao.urlLogo.isNotEmpty)
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(instituicao.urlLogo),
                      backgroundColor: Colors.grey[200],
                    ),
                  if (instituicao.urlLogo.isEmpty)
                    const CircleAvatar(radius: 40, child: Icon(Icons.business, size: 40)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      instituicao.nome,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  instituicao.descricaoCompleta,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),

            if (instituicao.necessidadesAtuais.isNotEmpty)
              Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Text("Necessidades Atuais", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    const Divider(),
                    ...instituicao.necessidadesAtuais.map((necessidade) {
                      return ListTile(
                        leading: Icon(
                          necessidade['urgente'] == true ? Icons.warning_amber_rounded : Icons.info_outline,
                          color: necessidade['urgente'] == true ? Colors.orangeAccent : Colors.blue,
                        ),
                        title: Text(necessidade['titulo'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(necessidade['descricao'] ?? ''),
                      );
                    })
                  ],
                ),
              ),

            if (instituicao.urlFotos.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
                    child: Text("Galeria de Fotos", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: instituicao.urlFotos.length,
                      itemBuilder: (context, index) {
                        return Card(
                          clipBehavior: Clip.antiAlias,
                          child: Image.network(
                            instituicao.urlFotos[index],
                            width: 250,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildInfoRow(Icons.location_on, 'Endereço', enderecoCompleto),
                    _buildInfoRow(Icons.phone, 'Telefone', instituicao.telefone),
                    _buildInfoRow(Icons.email, 'Email', instituicao.email),
                    _buildInfoRow(Icons.business, 'CNPJ', instituicao.cnpj),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}