import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/service_locator.dart';
import '../cubit/post_list_cubit.dart';
import '../cubit/post_list_state.dart';
import 'create_post_page.dart';

class PostListPage extends StatelessWidget {
  const PostListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PostListCubit>()..fetchPosts(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Posts')),
        body: Column(
          children: [
            // Campo de Busca
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Builder(
                builder: (context) {
                  return TextField(
                    decoration: const InputDecoration(
                      labelText: 'Buscar por título',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      context.read<PostListCubit>().filterPosts(value);
                    },
                  );
                },
              ),
            ),
            // Lista de Conteúdo com Reatividade
            Expanded(
              child: BlocBuilder<PostListCubit, PostListState>(
                builder: (context, state) {
                  if (state is PostListLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is PostListError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(state.message, textAlign: TextAlign.center),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () =>
                                context.read<PostListCubit>().fetchPosts(),
                            child: const Text('Tentar novamente'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is PostListSuccess) {
                    if (state.filteredPosts.isEmpty) {
                      return const Center(
                        child: Text('Nenhum post encontrado.'),
                      );
                    }

                    return ListView.builder(
                      itemCount: state.filteredPosts.length,
                      itemBuilder: (context, index) {
                        final post = state.filteredPosts[index];
                        return ListTile(
                          title: Text(
                            post.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            post.body,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () {
                            // Opcional/Diferencial: Navegar para detalhes
                          },
                        );
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton(
              onPressed: () async {
                // Abre formulário de criação e atualiza lista ao voltar
                final created = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreatePostPage()),
                );
                if (created == true && context.mounted) {
                  context.read<PostListCubit>().fetchPosts();
                }
              },
              child: const Icon(Icons.add),
            );
          },
        ),
      ),
    );
  }
}
