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

**DevHub** é um cliente GitHub para iOS que permite visualizar repositórios trending, favoritar repos offline, buscar e filtrar, ver perfil e autenticar via OAuth 2.0.

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

---

## 🛠️ Stack Técnica

```swift
- Swift 5.9
- SwiftUI 5.0
- SwiftData (iOS 17+)
- Combine
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

## 🚀 Como Rodar

### 1. Clone o projeto
```bash
git clone https://github.com/seu-usuario/DevHub.git
```

### 2. Configure OAuth App no GitHub
- https://github.com/settings/developers
- New OAuth App
- Callback: `devhub://callback`

### 3. Adicione credenciais
```swift
// Secrets.swift
enum Secrets {
    static let githubClientId = "SEU_CLIENT_ID"
    static let githubClientSecret = "SEU_CLIENT_SECRET"
}
```

### 4. Rode
```bash
open DevHub.xcodeproj
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
│   └── Services/
│
├── Features/
│   ├── Auth/
│   ├── Home/
│   ├── Profile/
│   ├── Repos/
│   └── Favorites/
│
├── Models/
│   ├── User.swift
│   ├── Repository.swift
│   └── FavoriteRepository.swift
│
├── UI/
│   ├── Components/
│   └── Theme/
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

### Decisões Técnicas

**GraphQL Manual vs Apollo:**
- ✅ Queries simples
- ✅ Menos dependências
- ❌ Apollo tem setup complexo

**SwiftData vs CoreData:**
- ✅ 70% menos código
- ✅ Type-safe
- ❌ iOS 17+ apenas

**MVVM vs VIPER:**
- ✅ Padrão SwiftUI
- ✅ Testável
- ❌ VIPER é overkill

---

## 🔜 Próximos Passos

### Sprint 4.2: Busca (2-3h)
- [ ] SearchView
- [ ] Filtros
- [ ] Histórico

### Sprint 4.3: Detalhes (3-4h)
- [ ] RepoDetailView
- [ ] README rendering
- [ ] Issues/PRs

### Sprint 5: Testes (2-3h)
- [ ] Unit tests
- [ ] UI tests
- [ ] CI/CD

### Sprint 6: UX (2-4h)
- [ ] Pagination
- [ ] Cache
- [ ] Animações

---

## 📊 Estatísticas

```
📝 Linhas de Código:    ~3.200+
📁 Arquivos:            45+
🎨 Componentes:         7
📱 Telas:               7
⏱️ Tempo:               ~12h
```

---

## 📚 Referências

- [SwiftUI Tutorials](https://developer.apple.com/tutorials/swiftui)
- [SwiftData Docs](https://developer.apple.com/documentation/swiftdata)
- [GitHub GraphQL](https://docs.github.com/graphql)
- [Hacking with Swift](https://www.hackingwithswift.com)

---

## 👨‍💻 Autor

**Jeff Araujo**

- GitHub: [@jeffaraujo](https://github.com/jeff77araujo)
- LinkedIn: [Jeff Araujo](https://www.linkedin.com/in/jeff-araujo-dev/)

---
