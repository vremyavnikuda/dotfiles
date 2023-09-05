#### Структура проекта /заметки
postmanKey:PMAK-641088a695f1a42ac25e0f74-454b1831c34d2e0285e0d76271dc3bc4b1

name: Automated API tests using Postman CLI

on: push

jobs:
  automated-api-tests:
    runs-on: windows-latest
    steps:
      - uses: actions/checkout@v3
      - name: Install Postman CLI
        run: |
          powershell.exe -NoProfile -InputFormat None -ExecutionPolicy AllSigned -Command "[System.Net.ServicePointManager]::SecurityProtocol = 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://dl-cli.pstmn.io/install/win64.ps1'))"
      - name: Login to Postman CLI
        run: postman login --with-api-key ${{ secrets.POSTMAN_API_KEY }}
      - name: Run API tests
        run: |
          # Lint your API using Postman CLI
          postman api lint --integration-id 135882