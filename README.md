# API de Geração de QR Code

Esta API permite que os usuários se registrem e gerem QR Codes com base nos dados fornecidos.

## Funcionalidades

- Registro de usuários.
- Geração de QR Codes.
- Autenticação via API Key.
- Documentação da API com Swagger.

## Instalação e Configuração

1. **Pré-requisitos**:
   - Python 3
   - Virtualenv (opcional)

2. **Configuração**:

   - Clone o repositório ou faça o download do código-fonte.
   - Recomenda-se criar um ambiente virtual:
     ```
     virtualenv venv
     source venv/bin/activate   # No Windows use: venv\Scripts\activate
     ```
   - Instale as dependências:
     ```
     pip install Flask Flask-SQLAlchemy qrcode[pil] flask-swagger-ui
     ```

3. **Inicialização do Banco de Dados**:

   - Execute o seguinte para criar as tabelas necessárias:
     ```python
     from app import db
     db.create_all()
     ```

4. **Executando o App**:

   - Inicie o servidor com:
     ```
     python app.py
     ```

## Uso

1. **Registro**:
   - Acesse `http://127.0.0.1:5000/dashboard` para se registrar.
   - Após o registro, uma API Key será gerada. Guarde-a, pois ela será usada para autenticar as requisições.

2. **Geração de QR Codes**:
   - Faça uma requisição POST para `http://127.0.0.1:5000/generate_qrcode` com o conteúdo desejado no corpo da requisição e a API Key no header `x-api-key`.

3. **Documentação da API**:
   - Acesse `http://127.0.0.1:5000/api/docs` para visualizar a documentação da API com Swagger.

## Detalhes Técnicos

- **Backend**: Desenvolvido em Flask.
- **Banco de Dados**: SQLite para simplicidade, mas pode ser facilmente adaptado para outros bancos de dados.
- **Autenticação**: Via API Key.
- **Documentação da API**: Swagger.