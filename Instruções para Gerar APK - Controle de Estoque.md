# Instruções para Gerar APK - Controle de Estoque

## Pré-requisitos

### 1. Flutter SDK
- Instale o Flutter SDK seguindo as instruções oficiais: https://flutter.dev/docs/get-started/install
- Adicione o Flutter ao PATH do sistema
- Verifique a instalação com: `flutter --version`

### 2. Android SDK
- Instale o Android Studio: https://developer.android.com/studio
- Durante a instalação, certifique-se de instalar:
  - Android SDK
  - Android SDK Platform-Tools
  - Android SDK Build-Tools
  - Android Emulator (opcional)

### 3. Configuração do Ambiente
- Execute `flutter doctor` para verificar se tudo está configurado corretamente
- Resolva quaisquer problemas indicados pelo comando

## Gerando o APK

### Método 1: Script Automatizado (Recomendado)
```bash
# No diretório do projeto
./build_apk.sh
```

### Método 2: Comandos Manuais
```bash
# 1. Instalar dependências
flutter pub get

# 2. Limpar build anterior (opcional)
flutter clean

# 3. Gerar APK de release
flutter build apk --release

# 4. Gerar APK dividido por arquitetura (menor tamanho)
flutter build apk --split-per-abi
```

## Localização dos APKs Gerados

Após o build bem-sucedido, os APKs estarão em:
- **APK universal**: `build/app/outputs/flutter-apk/app-release.apk`
- **APKs divididos**: `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk`, etc.

## Instalação no Dispositivo

### Via ADB (Android Debug Bridge)
```bash
# Conecte o dispositivo via USB com depuração USB habilitada
adb install build/app/outputs/flutter-apk/app-release.apk
```

### Via Transferência de Arquivo
1. Copie o APK para o dispositivo Android
2. No dispositivo, vá em Configurações > Segurança
3. Habilite "Fontes desconhecidas" ou "Instalar apps desconhecidos"
4. Use um gerenciador de arquivos para localizar e instalar o APK

## Configuração do Firebase

### Importante: Configuração Necessária
O aplicativo está configurado com as credenciais Firebase fornecidas no código. Para uso em produção:

1. **Crie seu próprio projeto Firebase**:
   - Acesse https://console.firebase.google.com
   - Crie um novo projeto
   - Adicione um app Android ao projeto

2. **Configure o Firestore**:
   - No console Firebase, vá em "Firestore Database"
   - Crie o banco de dados
   - Configure as regras de segurança apropriadas

3. **Atualize as credenciais**:
   - Baixe o arquivo `google-services.json`
   - Substitua as configurações em `lib/main.dart`
   - Ou use o arquivo `google-services.json` no diretório `android/app/`

### Regras de Segurança Sugeridas (Firestore)
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Permitir leitura e escrita para usuários autenticados
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
    
    // Para desenvolvimento/teste (menos seguro)
    // match /{document=**} {
    //   allow read, write: if true;
    // }
  }
}
```

## Solução de Problemas Comuns

### Erro: "Android SDK not found"
- Instale o Android Studio
- Configure a variável de ambiente ANDROID_HOME
- Execute `flutter config --android-sdk /caminho/para/android/sdk`

### Erro: "Gradle build failed"
- Verifique se o Java JDK está instalado (versão 8 ou superior)
- Limpe o projeto: `flutter clean`
- Tente novamente: `flutter build apk --release`

### Erro: "Firebase configuration"
- Verifique se as credenciais Firebase estão corretas
- Certifique-se de que o Firestore está habilitado no projeto Firebase
- Verifique as regras de segurança do Firestore

### APK muito grande
- Use `flutter build apk --split-per-abi` para gerar APKs menores
- Considere usar `flutter build appbundle` para distribuição via Play Store

## Distribuição

### Google Play Store
1. Gere um App Bundle: `flutter build appbundle --release`
2. Assine o bundle com sua chave de assinatura
3. Faça upload no Google Play Console

### Distribuição Direta
1. Use o APK gerado: `app-release.apk`
2. Distribua via download direto, email, ou outras plataformas

## Versioning

Para atualizar a versão do app:
1. Edite o arquivo `pubspec.yaml`
2. Altere a linha `version: 1.0.0+1` (formato: versão+build)
3. Gere novo APK

## Suporte

Para problemas específicos:
- Consulte a documentação oficial do Flutter: https://flutter.dev/docs
- Verifique issues no GitHub do Flutter: https://github.com/flutter/flutter/issues
- Documentação do Firebase: https://firebase.google.com/docs

