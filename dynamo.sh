#!/bin/bash
clear

# Colores ANSI
BG_BLUE='\033[48;5;27m'    # Fondo azul claro
ORANGE='\033[255m'    # Naranja (como la flecha de Amazon)
RESET='\033[0m'            # Reset

# Espaciado para simular un fondo más "logo-like"
echo -e "${BG_BLUE}   ${ORANGE}   AWS DynamoDB -LOCAL-                            ${BG_BLUE}   ${RESET}"

# Configuració AWS DynamoDB Local
export AWS_ACCESS_KEY_ID=dummy
export AWS_SECRET_ACCESS_KEY=dummy
ENDPOINT="http://localhost:8000"
REGION="us-west-2"
TABLE="Usuaris"

function crear_taula() {
  echo "Creant taula '$TABLE' si no existeix..."
  aws dynamodb create-table \
    --table-name $TABLE \
    --attribute-definitions AttributeName=UsuariID,AttributeType=S \
    --key-schema AttributeName=UsuariID,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
    --endpoint-url $ENDPOINT \
    --region $REGION 2>/dev/null

  echo "Esperant que la taula estiga activa..."
  aws dynamodb wait table-exists --table-name $TABLE --endpoint-url $ENDPOINT --region $REGION
}

function inserir_usuaris() {
  echo "Inserint 20 usuaris inventats..."
  aws dynamodb batch-write-item --request-items "{
    \"$TABLE\": [
      {\"PutRequest\": {\"Item\": {\"UsuariID\": {\"S\": \"u001\"}, \"Nom\": {\"S\": \"Jordi\"}, \"Edat\": {\"N\": \"30\"}}}},
      {\"PutRequest\": {\"Item\": {\"UsuariID\": {\"S\": \"u002\"}, \"Nom\": {\"S\": \"Laia\"}, \"Edat\": {\"N\": \"24\"}}}},
      {\"PutRequest\": {\"Item\": {\"UsuariID\": {\"S\": \"u003\"}, \"Nom\": {\"S\": \"Marc\"}, \"Edat\": {\"N\": \"31\"}}}},
      {\"PutRequest\": {\"Item\": {\"UsuariID\": {\"S\": \"u004\"}, \"Nom\": {\"S\": \"Anna\"}, \"Edat\": {\"N\": \"27\"}}}},
      {\"PutRequest\": {\"Item\": {\"UsuariID\": {\"S\": \"u005\"}, \"Nom\": {\"S\": \"Pau\"}, \"Edat\": {\"N\": \"29\"}}}},
      {\"PutRequest\": {\"Item\": {\"UsuariID\": {\"S\": \"u006\"}, \"Nom\": {\"S\": \"Núria\"}, \"Edat\": {\"N\": \"33\"}}}},
      {\"PutRequest\": {\"Item\": {\"UsuariID\": {\"S\": \"u007\"}, \"Nom\": {\"S\": \"Carles\"}, \"Edat\": {\"N\": \"35\"}}}},
      {\"PutRequest\": {\"Item\": {\"UsuariID\": {\"S\": \"u008\"}, \"Nom\": {\"S\": \"Clara\"}, \"Edat\": {\"N\": \"22\"}}}},
      {\"PutRequest\": {\"Item\": {\"UsuariID\": {\"S\": \"u009\"}, \"Nom\": {\"S\": \"David\"}, \"Edat\": {\"N\": \"41\"}}}},
      {\"PutRequest\": {\"Item\": {\"UsuariID\": {\"S\": \"u010\"}, \"Nom\": {\"S\": \"Irene\"}, \"Edat\": {\"N\": \"38\"}}}},
      {\"PutRequest\": {\"Item\": {\"UsuariID\": {\"S\": \"u011\"}, \"Nom\": {\"S\": \"Joan\"}, \"Edat\": {\"N\": \"36\"}}}},
      {\"PutRequest\": {\"Item\": {\"UsuariID\": {\"S\": \"u012\"}, \"Nom\": {\"S\": \"Marta\"}, \"Edat\": {\"N\": \"26\"}}}},
      {\"PutRequest\": {\"Item\": {\"UsuariID\": {\"S\": \"u013\"}, \"Nom\": {\"S\": \"Víctor\"}, \"Edat\": {\"N\": \"32\"}}}},
      {\"PutRequest\": {\"Item\": {\"UsuariID\": {\"S\": \"u014\"}, \"Nom\": {\"S\": \"Sílvia\"}, \"Edat\": {\"N\": \"40\"}}}},
      {\"PutRequest\": {\"Item\": {\"UsuariID\": {\"S\": \"u015\"}, \"Nom\": {\"S\": \"Àlex\"}, \"Edat\": {\"N\": \"28\"}}}},
      {\"PutRequest\": {\"Item\": {\"UsuariID\": {\"S\": \"u016\"}, \"Nom\": {\"S\": \"Eva\"}, \"Edat\": {\"N\": \"34\"}}}},
      {\"PutRequest\": {\"Item\": {\"UsuariID\": {\"S\": \"u017\"}, \"Nom\": {\"S\": \"Roger\"}, \"Edat\": {\"N\": \"37\"}}}},
      {\"PutRequest\": {\"Item\": {\"UsuariID\": {\"S\": \"u018\"}, \"Nom\": {\"S\": \"Gemma\"}, \"Edat\": {\"N\": \"23\"}}}},
      {\"PutRequest\": {\"Item\": {\"UsuariID\": {\"S\": \"u019\"}, \"Nom\": {\"S\": \"Oriol\"}, \"Edat\": {\"N\": \"39\"}}}},
      {\"PutRequest\": {\"Item\": {\"UsuariID\": {\"S\": \"u020\"}, \"Nom\": {\"S\": \"Lídia\"}, \"Edat\": {\"N\": \"21\"}}}}
    ]
  }" \
  --endpoint-url $ENDPOINT \
  --region $REGION
}

function mostrar_usuaris() {
  aws dynamodb scan \
    --table-name $TABLE \
    --endpoint-url $ENDPOINT \
    --region $REGION \
    --output json | jq -r '.Items[] | [.UsuariID.S, .Nom.S, .Edat.N] | @tsv'
}

function exportar_usuaris() {
  echo "Exportant dades a usuaris.json..."
  aws dynamodb scan \
    --table-name $TABLE \
    --endpoint-url $ENDPOINT \
    --region $REGION \
    --output json > usuaris.json
  echo "🖒 Fitxer usuaris.json creat."
}

function importar_usuaris() {
  read -p "🗀 Introdueix el nom del fitxer JSON a importar (ex: usuaris.json): " fitxer
  if [ ! -f "$fitxer" ]; then
    echo "✖ El fitxer '$fitxer' no existeix."
    return
  fi
  echo ".... Important dades des de $fitxer..."
  total=$(jq '.Items | length' "$fitxer")
  for ((i=0; i<total; i++)); do
    # Aquí només agafem l'element individual de Items[i]
    item=$(jq -c ".Items[$i]" "$fitxer")
    aws dynamodb put-item \
      --table-name $TABLE \
      --item "$item" \
      --endpoint-url $ENDPOINT \
      --region $REGION
  done
  echo "🖒 Importació completada."
}

function filtrar_per_edat() {
  read -p "[?] Edat mínima? " edat_min
  read -p "[?] Edat màxima? " edat_max

  # Escaneja i filtra amb jq per edat
  aws dynamodb scan \
    --table-name $TABLE \
    --endpoint-url $ENDPOINT \
    --region $REGION \
    --output json | jq -r --arg min "$edat_min" --arg max "$edat_max" '
      .Items[]
      | select((.Edat.N | tonumber) >= ($min|tonumber) and (.Edat.N | tonumber) <= ($max|tonumber))
      | [.UsuariID.S, .Nom.S, .Edat.N]
      | @tsv
    '
}

function cercar_per_nom() {
  read -p "🔎 Cerca per nom (subcadena): " text
  text_lower=$(echo "$text" | tr '[:upper:]' '[:lower:]')

  aws dynamodb scan \
    --table-name $TABLE \
    --endpoint-url $ENDPOINT \
    --region $REGION \
    --output json | jq -r --arg txt "$text_lower" '
      .Items[]
      | select((.Nom.S | ascii_downcase) | contains($txt))
      | [.UsuariID.S, .Nom.S, .Edat.N]
      | @tsv
    '
}

# --- Execució principal ---
crear_taula
inserir_usuaris

echo "Usuaris actuals:"
mostrar_usuaris

# Menú interactiu
while true; do
  echo ""
  read -p "Vols [import], [export], [llistar], [filtrar], [cercar] o [eixir]? " accio

  case $accio in
    export)
      exportar_usuaris
      ;;
    import)
      importar_usuaris
      ;;
    llistar)
      echo "Usuaris actuals:"
      mostrar_usuaris
      ;;
    filtrar)
      filtrar_per_edat
      ;;
    cercar)
      cercar_per_nom
      ;;
    eixir)
      echo "*** Fins la pròxima! ***"
      break
      ;;
    *)
      echo "Opció no vàlida. Escriu import, export, llistar, filtrar, cercar o eixir."
      ;;
  esac
done

