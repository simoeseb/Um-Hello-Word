# um_hello_word

A new Swift project.

Documentação do Aplicativo

Visão Geral

Este aplicativo SwiftUI permite que os usuários insiram apelidos em um campo de texto, salvem-nos em uma lista e visualizem essa lista na mesma tela. Os apelidos devem ter entre 3 e 20 caracteres e não podem se repetir na lista. Além disso, há uma opção para navegar para uma tela de "Postagens", onde os dados de uma API podem ser exibidos.
Funcionalidades

Adicionar Apelidos
* Campo de Entrada: Os usuários podem inserir apelidos no campo de texto fornecido. O texto de placeholder indica os requisitos para o apelido: mínimo de 3 e máximo de 20 caracteres.
* Botão Salvar: Após inserir um apelido, o usuário pode clicar no botão "Salvar" para adicionar o apelido à lista. Se o apelido não atender aos critérios (comprimento ou unicidade), uma mensagem de erro será exibida.

Validação
* Comprimento do Apelido: O apelido deve ter entre 3 e 20 caracteres. Uma mensagem de erro será exibida se o critério não for atendido.
* Unicidade do Apelido: Apelidos repetidos não são permitidos. Uma mensagem de erro será exibida se o apelido já estiver na lista.
Visualização de Apelidos Salvos
* Uma lista exibe todos os apelidos salvos que atendem aos critérios. Essa lista é atualizada cada vez que um novo apelido é adicionado com sucesso.
Navegação para Postagens
* Tela de Postagens: Há um botão "Postagens" que, quando clicado, leva o usuário para uma nova tela onde os dados da API podem ser exibidos. Essa funcionalidade depende da implementação da PostsView.
Componentes UI

ContentView
A ContentView é a tela principal do aplicativo, contendo todos os componentes de UI para a funcionalidade de adição e visualização de apelidos.
* @State private var inputText: String = "": Armazena o texto atual no campo de entrada.
* @State private var savedNames: [String] = []: Mantém a lista de apelidos salvos.
* @State private var errorMessage: String?: Armazena a mensagem de erro a ser exibida, se houver.
PostsView
A PostsView (não detalhada nesta documentação) seria a tela para exibir os dados da API. A estrutura e funcionalidade específicas dependerão dos dados da API e dos requisitos de design.
