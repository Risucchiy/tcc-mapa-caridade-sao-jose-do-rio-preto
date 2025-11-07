import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';
import '../models/instituicao_model.dart';
import '../services/firestore_service.dart';
import 'detail_screen.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final MapController _mapController = MapController();
  static const LatLng _posicaoInicial = LatLng(-20.8197, -49.3792);

  List<String> _selectedCategories = [];
  Instituicao? _selectedInstitution;

  final List<String> _availableCategories = ['idosos', 'crianças', 'animais', 'saúde'];

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  Widget _buildTopInfoPanel() {
    const searchBarHeight = 80.0;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      top: _selectedInstitution != null ? searchBarHeight : -200.0, // <-- CORREÇÃO APLICADA AQUI
      left: 10.0,
      right: 10.0,
      child: Card(
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: _selectedInstitution?.urlLogo != null && _selectedInstitution!.urlLogo.isNotEmpty
                        ? NetworkImage(_selectedInstitution!.urlLogo)
                        : null,
                    child: _selectedInstitution?.urlLogo == null || _selectedInstitution!.urlLogo.isEmpty
                        ? const Icon(Icons.business, size: 30)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedInstitution?.nome ?? '',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_selectedInstitution?.endereco['rua'] ?? ''}, ${_selectedInstitution?.endereco['numero'] ?? ''}',
                          style: TextStyle(color: Colors.grey[600]),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => setState(() => _selectedInstitution = null),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 40),
                ),
                onPressed: () {
                  if (_selectedInstitution != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(instituicao: _selectedInstitution!),
                      ),
                    );
                  }
                },
                child: const Text('Ver Mais Detalhes'),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Filtrar por Categoria'),
              content: Wrap(
                spacing: 8.0,
                children: _availableCategories.map((category) {
                  final isSelected = _selectedCategories.contains(category);
                  return FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setDialogState(() {
                        if (selected) {
                          _selectedCategories.add(category);
                        } else {
                          _selectedCategories.remove(category);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() => _selectedCategories = []);
                    Navigator.pop(context);
                  },
                  child: const Text('Limpar'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {});
                    Navigator.pop(context);
                  },
                  child: const Text('Aplicar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instituições de Caridade'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: StreamBuilder<List<Instituicao>>(
        stream: _firestoreService.getInstituicoes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar os dados: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma instituição encontrada.'));
          }

          final allInstituicoes = snapshot.data!;
          final filteredInstitutions = allInstituicoes.where((inst) {
            if (!inst.ativa) return false;
            return _selectedCategories.isEmpty || _selectedCategories.any((cat) => inst.categorias.contains(cat));
          }).toList();

          final markers = filteredInstitutions.map((inst) {
            return Marker(
              point: LatLng(inst.localizacao.latitude, inst.localizacao.longitude),
              child: GestureDetector(
                onTap: () => setState(() => _selectedInstitution = inst),
                child: const Icon(Icons.location_pin, color: Colors.red, size: 40.0),
              ),
            );
          }).toList();

          return Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _posicaoInicial,
                  initialZoom: 13.0,
                  onTap: (_, __) => setState(() => _selectedInstitution = null),
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.ongprojeto',
                    tileProvider: CancellableNetworkTileProvider(),
                  ),
                  MarkerLayer(markers: markers),
                ],
              ),
              _buildTopInfoPanel(),
              
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  elevation: 8,
                  child: Autocomplete<Instituicao>(
                    displayStringForOption: (Instituicao option) => option.nome,
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text == '') {
                        return const Iterable<Instituicao>.empty();
                      }
                      return allInstituicoes.where((Instituicao option) {
                        return option.nome.toLowerCase().contains(textEditingValue.text.toLowerCase());
                      });
                    },
                    onSelected: (Instituicao selection) {
                      setState(() {
                        _selectedInstitution = selection;
                        _mapController.move(
                          LatLng(selection.localizacao.latitude, selection.localizacao.longitude),
                          16.0,
                        );
                      });
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                      return TextField(
                        controller: textEditingController,
                        focusNode: focusNode,
                        decoration: InputDecoration(
                          hintText: 'Buscar por nome...',
                          prefixIcon: const Icon(Icons.search),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              textEditingController.clear();
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const FavoritesScreen()));
        },
        child: const Icon(Icons.favorite),
      ),
    );
  }
}