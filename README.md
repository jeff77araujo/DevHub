# 📱 DevHub - GitHub Client iOS

> Um cliente GitHub nativo para iOS construído com SwiftUI, focado em aprendizado de tecnologias modernas e arquitetura profissional.

[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)
[![iOS](https://img.shields.io/badge/iOS-17.0+-blue.svg)](https://www.apple.com/ios)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-5.0-green.svg)](https://developer.apple.com/xcode/swiftui/)
[![License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](LICENSE)

---

## 📋 Índice

- [Sobre o Projeto](#-sobre-o-projeto)
- [Features Implementadas](#-features-implementadas)
- [Stack Técnica](#️-stack-técnica)
- [Arquitetura](#️-arquitetura)
- [Conceitos Aprendidos](#-conceitos-aprendidos)
- [Como Rodar](#-como-rodar)
- [Estrutura do Projeto](#-estrutura-do-projeto)
- [Aprendizados Detalhados](#-aprendizados-detalhados)
- [Próximos Passos](#-próximos-passos)

---

## 🎯 Sobre o Projeto

**DevHub** é um cliente GitHub para iOS que permite visualizar repositórios, favoritar repos offline, buscar e filtrar com histórico persistente, ver perfil e autenticar via OAuth 2.0.

Este projeto foi desenvolvido com foco em **aprendizado técnico** e **boas práticas**, servindo como **material de estudos** para iOS Development.

---

## ✨ Features Implementadas

### ✅ Sprint 1: Setup e Autenticação (2h)
- [x] Projeto Xcode + Git + SPM
- [x] OAuth 2.0 com GitHub
- [x] Keychain para tokens
- [x] Design System (AppTheme)

### ✅ Sprint 2: GraphQL e Perfil (3h)
- [x] GraphQL manual (sem Apollo)
- [x] Tela de perfil com dados reais
- [x] Componentes reutilizáveis

### ✅ Sprint 3: Repositórios e Favoritos (4h)
- [x] Trending repos
- [x] SwiftData offline
- [x] Sistema de favoritos CRUD
- [x] Pull to refresh

### ✅ Sprint 4.1: Tela de Favoritos (3h)
- [x] FavoritesView completa
- [x] Busca local real-time
- [x] Ordenação (data/nome/stars)
- [x] Empty states
- [x] **FIX:** Crash EXC_BAD_ACCESS

### ✅ Sprint 4.2: Busca de Repositórios (3h)
- [x] SearchView com debounce (500ms)
- [x] Integração GraphQL Search API
- [x] Filtros avançados (linguagem, stars, ordenação)
- [x] Histórico de buscas (SwiftData)
- [x] 5 estados de UI (empty/loading/results/error/no-results)
- [x] Badge de filtros ativos
- [x] **FIX:** SearchFilters não encontrado
- [x] **FIX:** Decodificação JSON
- [x] **FIX:** Repository incompatível

---

## 🛠️ Stack Técnica

```swift
- Swift 5.9
- SwiftUI 5.0
- SwiftData (iOS 17+)
- Combine (Debounce)
- Firebase/Auth
- Alamofire
- KeychainSwift
```

---

## 🏗️ Arquitetura - MVVM

```
View (SwiftUI)
    ↓ Observa @Published
ViewModel (ObservableObject + @MainActor)
    ↓ Chama métodos
Service / Repository
    ↓ Retorna
Model (Struct Codable)
```

**Exemplo:**
```swift
// MODEL
struct Repository: Codable {
    let name: String
    let stars: Int
}

// SERVICE
class GitHubService {
    func fetchRepos() async throws -> [Repository] { }
}

// VIEWMODEL
@MainActor
class ReposViewModel: ObservableObject {
    @Published var repos: [Repository] = []
    
    func load() async {
        repos = try await service.fetchRepos()
    }
}

// VIEW
struct ReposView: View {
    @StateObject var viewModel = ReposViewModel()
    
    var body: some View {
        List(viewModel.repos) { repo in
            Text(repo.name)
        }
    }
}
```

---

## 📚 Conceitos Aprendidos

### 1️⃣ OAuth 2.0 - Autenticação Segura

**Fluxo:**
```
1. App abre GitHub no navegador
2. User autoriza
3. GitHub retorna código
4. App troca código por token
5. Token salvo no Keychain
6. Todas requests usam: Authorization: Bearer {token}
```

**Por que Keychain?**
- ✅ Criptografia AES-256
- ✅ Secure Enclave
- ❌ UserDefaults NÃO é seguro!

---

### 2️⃣ GraphQL - Query Language

**REST vs GraphQL:**
```
REST:
GET /user     → Over-fetching
GET /repos    → 2 requests

GraphQL:
query {
  user { name }
  repos { name stars }
}
→ 1 request, dados exatos
```

**Search API do GitHub:**
```graphql
query SearchRepositories($searchQuery: String!) {
  search(query: $searchQuery, type: REPOSITORY, first: 30) {
    repositoryCount
    edges {
      node {
        ... on Repository {
          id
          name
          stargazerCount
        }
      }
    }
  }
}
```

---

### 3️⃣ SwiftData - Persistência Moderna

**CoreData vs SwiftData:**
```swift
// CoreData: ~30 linhas
let entity = NSEntityDescription.entity...
let favorite = NSManagedObject...
favorite.setValue(name, forKey: "name")
try context.save()

// SwiftData: ~10 linhas
@Model
class Favorite {
    var name: String
}

context.insert(favorite)
try context.save()
```

**70% menos código!**

**Sprint 4.2 - Múltiplos Modelos:**
```swift
// DevHubApp.swift
let schema = Schema([
    FavoriteRepository.self,
    SearchHistory.self  // ← Novo!
])
```

---

### 4️⃣ Property Wrappers - @State vs @StateObject

**DIFERENÇA CRÍTICA:**
```swift
// ❌ ERRADO - Causou crash!
@State var viewModel: ViewModel?
// @State NÃO observa classes

// ✅ CORRETO
@StateObject var viewModel = ViewModel()
// @StateObject cria E observa
```

**Quando usar:**
- `@State` → Int, String, Bool
- `@StateObject` → ViewModels (cria)
- `@ObservedObject` → ViewModels (recebe)

---

### 5️⃣ Memory Management - Evitando Crashes

**Problema Real:**
```swift
// ❌ CAUSOU CRASH
class Service {
    private let context: ModelContext  // Referência forte!
    
    init(context: ModelContext) {
        self.context = context  // Captura
    }
}

// SwiftUI recria View → context deallocado → CRASH!
```

**Solução:**
```swift
// ✅ CORRETO
class Service {
    init() { }  // Sem captura
    
    func fetch(context: ModelContext) {
        // Recebe por parâmetro
    }
}
```

---

### 6️⃣ Dependency Injection

```swift
// ❌ RUIM
class ViewModel {
    let service = Service()  // Acoplado
}

// ✅ BOM
class ViewModel {
    let service: ServiceProtocol
    
    init(service: ServiceProtocol) {
        self.service = service
    }
}

// Produção:
ViewModel(service: RealService())

// Testes:
ViewModel(service: MockService())
```

---

### 7️⃣ Async/Await - Concorrência

**Antes (Closures):**
```swift
fetchUser { result in
    switch result {
    case .success(let user):
        print(user)
    case .failure(let error):
        print(error)
    }
}
```

**Depois (Async/Await):**
```swift
do {
    let user = try await fetchUser()
    print(user)
} catch {
    print(error)
}
```

---

### 8️⃣ Design System

```swift
// ❌ SEM
Text("Título")
    .font(.system(size: 24))
    .foregroundColor(.blue)

// ✅ COM
Text("Título")
    .font(AppTheme.Typography.title)
    .foregroundColor(AppTheme.Colors.primary)
```

**Consistência visual!**

---

### 9️⃣ Combine - Debounce para Performance

**Problema:** Buscar a cada tecla = spam na API

**Solução:**
```swift
$searchText
    .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
    .removeDuplicates()
    .sink { query in
        Task {
            await performSearch(query: query)
        }
    }
    .store(in: &cancellables)
```

**Resultado:** Só busca 500ms DEPOIS que o usuário parou de digitar!

---

### 🔟 Tratamento de Erros GraphQL

**Problema:** API retorna `"errors"` mas código tentava decodificar `"data"` → crash

**Solução:**
```swift
// 1. Verificar se há erro ANTES de decodificar
if let errors = json["errors"] as? [[String: Any]] {
    let messages = errors.compactMap { $0["message"] as? String }
    throw ServiceError.networkError(messages.joined(separator: ", "))
}

// 2. SÓ AGORA decodificar
let response = try decoder.decode(Response.self, from: data)
```

**Logs detalhados:**
```swift
print("📡 Status code: \(httpResponse.statusCode)")
print("📄 JSON bruto: \(jsonString.prefix(500))...")
print("❌ Erro GraphQL: \(errorMessages)")
```

---

## 🚀 Como Rodar

### 1. Clone o projeto
```bash
git clone https://github.com/jeff77araujo/DevHub.git
cd DevHub
```

### 2. Configure OAuth App no GitHub
- Acesse: https://github.com/settings/developers
- Clique em **New OAuth App**
- Preencha:
  - **Application name:** DevHub
  - **Homepage URL:** https://github.com/jeff77araujo/DevHub
  - **Authorization callback URL:** `devhub://callback`
- Copie **Client ID** e **Client Secret**

### 3. Adicione credenciais
Crie o arquivo `Secrets.swift` em `DevHub/Core/Security/`:

```swift
// Secrets.swift
enum Secrets {
    static let githubClientId = "SEU_CLIENT_ID_AQUI"
    static let githubClientSecret = "SEU_CLIENT_SECRET_AQUI"
}
```

⚠️ **IMPORTANTE:** Este arquivo está no `.gitignore` por segurança!

### 4. Instale dependências
```bash
# SPM instala automaticamente ao abrir o projeto
open DevHub.xcodeproj
```

### 5. Rode o projeto
```bash
# No Xcode:
Cmd + R
```

---

## 📂 Estrutura do Projeto

```
DevHub/
├── App/
│   └── DevHubApp.swift
│
├── Core/
│   ├── Security/
│   │   ├── Secrets.swift
│   │   └── KeychainManager.swift
│   ├── Repositories/
│   │   ├── GitHubReposService.swift
│   │   └── GitHubSearchService.swift  ← Sprint 4.2
│   └── Services/
│       └── FavoritesService.swift
│
├── Features/
│   ├── Auth/
│   │   ├── AuthService.swift
│   │   └── LoginView.swift
│   ├── Home/
│   │   └── HomeView.swift
│   ├── Profile/
│   │   ├── ProfileViewModel.swift
│   │   └── ProfileView.swift
│   ├── Repos/
│   │   ├── ReposViewModel.swift
│   │   └── ReposListView.swift
│   ├── Favorites/
│   │   ├── FavoritesViewModel.swift
│   │   └── FavoritesView.swift
│   └── Search/  ← Sprint 4.2
│       ├── SearchViewModel.swift
│       ├── SearchView.swift
│       └── SearchFiltersView.swift
│
├── Models/
│   ├── User.swift
│   ├── Repository.swift
│   ├── FavoriteRepository.swift
│   ├── SearchHistory.swift  ← Sprint 4.2
│   └── SearchFilters.swift  ← Sprint 4.2
│
├── UI/
│   ├── Components/
│   │   ├── RepoCard.swift
│   │   ├── ProfileHeader.swift
│   │   └── EmptyStateView.swift
│   └── Theme/
│       └── AppTheme.swift
│
└── MainTabView.swift
```

---

## 🎓 Aprendizados Detalhados

### Problema 1: Crash EXC_BAD_ACCESS

**Diagnóstico:**
```
1. Stack trace → FavoritesService.swift linha 13
2. Problema: self.modelContext = modelContext
3. Referência forte causava acesso a memória deallocada
```

**Solução:**
```swift
// ANTES (❌):
private let modelContext: ModelContext

// DEPOIS (✅):
func fetch(context: ModelContext) { }
```

**Lição:** Evitar captura de `ModelContext` em properties.

---

### Problema 2: View não atualiza

**Causa:**
```swift
@State private var viewModel: ViewModel?
// @State NÃO observa ObservableObject
```

**Solução:**
```swift
@StateObject private var viewModel = ViewModel()
```

**Lição:** Property wrappers corretos são CRÍTICOS.

---

### Problema 3: SearchFilters não encontrado (Sprint 4.2)

**Erro:**
```
Cannot find type 'SearchFilters' in scope
```

**Causa:** Arquivo `SearchFilters.swift` não foi criado na primeira versão.

**Solução:**
Criar modelo completo com enums:
```swift
struct SearchFilters {
    var language: String?
    var minStars: Int?
    var sortBy: SortOption
    
    enum Language: String, CaseIterable {
        case all = ""
        case swift = "Swift"
        case python = "Python"
        // ...
    }
    
    enum StarsFilter: Int, CaseIterable {
        case any = 0
        case oneK = 1000
        case fiveK = 5000
        // ...
    }
}
```

---

### Problema 4: Erro de Decodificação JSON (Sprint 4.2)

**Erro:**
```
keyNotFound(CodingKeys(stringValue: "data", intValue: nil))
```

**Causa:** API retornava `"errors"` mas código tentava decodificar `"data"` direto.

**Solução:**
```swift
// 1. Verificar erros ANTES
if let errors = json["errors"] as? [[String: Any]] {
    let errorMessages = errors.compactMap { $0["message"] as? String }
    throw ServiceError.networkError(errorMessages.joined(separator: ", "))
}

// 2. SÓ AGORA decodificar
let searchResponse = try decoder.decode(SearchRepositoriesResponse.self, from: data)
```

**Logs adicionados:**
- Status HTTP
- JSON bruto (primeiros 500 chars)
- Mensagens de erro GraphQL
- Debug detalhado de `DecodingError`

---

### Problema 5: Repository incompatível (Sprint 4.2)

**Erro:**
```
Extra arguments at positions #3, #10 in call
Missing argument for parameter 'url' in call
Cannot find 'Owner' in scope
```

**Causa:** Inicializador do `Repository` era diferente do esperado pelo search.

**Solução:**
Ajustar mapeamento no `GitHubSearchService`:
```swift
let repo = Repository(
    id: edge.node.id,
    name: edge.node.name,
    owner: edge.node.owner.login,  // String, não struct Owner
    ownerAvatarURL: edge.node.owner.avatarUrl,
    description: edge.node.description,
    url: edge.node.url,
    language: edge.node.primaryLanguage?.name,
    languageColor: edge.node.primaryLanguage?.color,
    stargazersCount: edge.node.stargazerCount,
    forksCount: edge.node.forkCount,
    updatedAt: edge.node.updatedAt
)
```

---

### Decisões Técnicas

**GraphQL Manual vs Apollo:**
- ✅ Queries simples
- ✅ Menos dependências
- ✅ Controle total
- ❌ Apollo tem setup complexo

**SwiftData vs CoreData:**
- ✅ 70% menos código
- ✅ Type-safe
- ✅ Macros automáticas
- ❌ iOS 17+ apenas

**MVVM vs VIPER:**
- ✅ Padrão SwiftUI
- ✅ Testável
- ✅ Menos boilerplate
- ❌ VIPER é overkill

**Debounce 500ms vs Tempo Real:**
- ✅ Evita spam na API
- ✅ Melhor UX (não fica "piscando")
- ✅ Rate limit do GitHub
- ❌ Delay mínimo (imperceptível)

---

## 🔜 Próximos Passos

### Sprint 4.3: Detalhes do Repositório (3-4h)
- [ ] RepoDetailView
- [ ] README rendering (Markdown)
- [ ] Issues count
- [ ] Contributors
- [ ] Linguagens (gráfico)

### Sprint 5: Testes Unitários (2-3h)
- [ ] Unit tests (ViewModels)
- [ ] Mock services
- [ ] Coverage 80%+
- [ ] CI/CD setup

### Sprint 6: Melhorias UX (2-4h)
- [ ] Pagination (infinite scroll)
- [ ] Cache de imagens
- [ ] Animações (skeleton loading)
- [ ] Dark mode otimizado
- [ ] Haptic feedback

---

## 📊 Estatísticas

```
📝 Linhas de Código:    ~4.400+
📁 Arquivos:            55+
🎨 Componentes:         9
📱 Telas:               9
⏱️ Tempo:               ~15h
🐛 Bugs Corrigidos:     15
```

**Sprint 4.2 adicionou:**
- +600 linhas de código
- +8 arquivos
- +2 componentes (SearchView, SearchFiltersView)
- +3h desenvolvimento
- +5 bugs corrigidos

---

## 📚 Referências

- [SwiftUI Tutorials](https://developer.apple.com/tutorials/swiftui)
- [SwiftData Docs](https://developer.apple.com/documentation/swiftdata)
- [GitHub GraphQL](https://docs.github.com/graphql)
- [GitHub Search API](https://docs.github.com/graphql/reference/queries#search)
- [Hacking with Swift](https://www.hackingwithswift.com)
- [Combine Framework](https://developer.apple.com/documentation/combine)

---

## 👨‍💻 Autor

**Jeff Araujo**

- GitHub: [@jeff77araujo](https://github.com/jeff77araujo)
- LinkedIn: [Jeff Araujo](https://www.linkedin.com/in/jeff-araujo-dev/)
