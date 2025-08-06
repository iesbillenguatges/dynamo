# DynamoDB Local + Script de gestió d'usuaris

Aquest projecte et permet treballar amb **Amazon DynamoDB Local** mitjançant un script Bash que automatitza la creació de taules, inserció, exportació, importació i consulta d’usuaris ficticis. Ideal per a entorns de desenvolupament i proves.

---

## Què és DynamoDB Local?

**DynamoDB Local** és una versió local del servei de base de dades NoSQL d’Amazon (AWS). Permet desenvolupar i fer proves **sense connexió a internet ni accés a AWS** real.

DockerHub: [https://hub.docker.com/r/amazon/dynamodb-local](https://hub.docker.com/r/amazon/dynamodb-local)

---

## Llançar DynamoDB Local amb Docker

Executa:

```bash
docker run -d -p 8000:8000 --name dynamodb-local amazon/dynamodb-local
```

- Pots accedir en `http://localhost:8000`
- No persisteix dades (reiniciant es borra tot)

Per comprovar que funciona:
```bash
curl http://localhost:8000
```

---

## Què és AWS CLI?

AWS CLI (Amazon Web Services Command Line Interface) és una eina de línia de comandes que et permet interactuar amb els serveis d’AWS directament des del terminal o consola, sense haver d’utilitzar la interfície web d’AWS.

Per a què serveix? Amb AWS CLI pots:

- Administrar recursos d’AWS (com EC2, S3, Lambda, etc.)
- Automatitzar tasques (com pujar fitxers a S3, crear instàncies EC2, etc.)
- Executar scripts per fer operacions repetitives
- Integrar AWS en processos de DevOps o CI/CD

## Instal·lar l’AWS CLI

### Ubuntu / Debian

```bash
sudo apt update
sudo apt install unzip curl -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

Comprova la instal·lació:

```bash
aws --version
```

### Windows

1. Descarrega i executa aquest instal·lador: [https://awscli.amazonaws.com/AWSCLIV2.msi](https://awscli.amazonaws.com/AWSCLIV2.msi)
2. Reinicia PowerShell o terminal
3. Comprova:

```powershell
aws --version
```

---

## Com funciona el script?

Aquest script:

1. **Crea una taula DynamoDB** anomenada `Usuaris`
2. **Insereix 20 usuaris ficticis** amb nom i edat
3. Mostra un **menú interactiu** amb les opcions següents:

### Menú d'opcions:

- `llistar` – Mostra tots els usuaris
- `export` – Exporta les dades a `usuaris.json`
- `import` – Importa dades des de un fitxer JSON
- `filtrar` – Filtra usuaris per edat mínima i màxima
- `cercar` – Cerca usuaris pel nom (conté text)
- `eixir` – Ix del programa

---

## Requisits

- `aws` CLI (instal·lat i accessible des de terminal)
- `jq` (per a processar JSON)

Instal·la `jq` si no el tens:

```bash
# Ubuntu/Debian
sudo apt install jq -y

# macOS (amb Homebrew)
brew install jq
```

---

## Configuració automàtica d’AWS (ja gestionada pel script)

El script exporta aquestes variables fictícies per treballar amb DynamoDB local:

```bash
export AWS_ACCESS_KEY_ID=unaArreu
export AWS_SECRET_ACCESS_KEY=unaArreu
```

També utilitza:

- **Endpoint**: `http://localhost:8000`
- **Regió**: `us-west-2`

---

## Com executar-lo

Fes-lo executable:

```bash
chmod +x dynamodb-local.sh
```

Llança’l:

```bash
./dynamodb-local.sh
```

Assegura’t que el contenidor de DynamoDB Local està en marxa abans de començar.

---

## Parar i eliminar el contenidor

Quan acabes, pots parar i eliminar el contenidor:

```bash
docker stop dynamodb-local
docker rm dynamodb-local
```

---

## Exemple de fitxer `usuaris.json`

Aquest fitxer es genera quan fas `export`, i pot tornar-se a importar per carregar les dades:

```json
{
  "Items": [
    {
      "UsuariID": {"S": "u001"},
      "Nom": {"S": "Jordi"},
      "Edat": {"N": "30"}
    },
    ...
  ]
}
```

---

## Recursos útils

- [DynamoDB Local (AWS Docs)](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DynamoDBLocal.html)
- [Documentació AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/)
- [Boto3 (SDK de Python per a AWS)](https://boto3.amazonaws.com/v1/documentation/api/latest/index.html)

---

## Autor

Creat per a finalitats educatives i de desenvolupament local per xaviblanes (iesbi_np). No utilitza serveis reals per tant no té cap cost.

---
