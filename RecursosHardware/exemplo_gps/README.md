# 🌦️ Exemplo GPS & Clima em Tempo Real (Flutter)

Projeto Flutter desenvolvido para leitura de recursos de hardware (GPS/Geolocalização) integrado com a API da **OpenWeatherMap** para consulta de temperatura em graus Celsius (°C).

---

## 🚀 Funcionalidades

1. **Inicialização com Solicitação Imediata de Permissão (`initState`)**:
   - Assim que o aplicativo inicia, verifica se o serviço de GPS está ativo e solicita a permissão ao usuário via `Geolocator.requestPermission()`.
   - Exibe a caixa de diálogo nativa do sistema operacional (Android / iOS / Web).

2. **Captura das Coordenadas**:
   - Com a permissão concedida, faz a leitura da **Latitude** e **Longitude** com alta precisão (`LocationAccuracy.high`).

3. **Consulta de Temperatura na OpenWeatherMap**:
   - As coordenadas são enviadas para o endpoint:
     ```
     https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&units=metric&lang=pt_br&appid={SUA_CHAVE}
     ```
   - O parâmetro `units=metric` garante o retorno dos dados em **Celsius (°C)**.
   - Retorna temperatura, sensação térmica, umidade, velocidade do vento (convertida para km/h) e amplitude térmica (mín/máx).

4. **Configuração Amigável de Chave de API**:
   - Diálogo nativo acessível pelo ícone de chave no `AppBar` para colar a chave gerada em [OpenWeatherMap API Keys](https://home.openweathermap.org/api_keys) sem recompilar.

---

## 🛠️ Configurações Realizadas

1. **Dependências (`pubspec.yaml`)**:
   - `geolocator`: Biblioteca para acesso ao hardware de localização.
   - `http`: Biblioteca para consumo de APIs REST.

2. **Permissões Android (`AndroidManifest.xml`)**:
   ```xml
   <uses-permission android:name="android.permission.INTERNET" />
   <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
   <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
   ```

---

## 📱 Como Executar

```bash
flutter pub get
flutter run
```
