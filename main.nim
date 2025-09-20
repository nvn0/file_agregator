import os, strutils, terminal, strformat

# --- Ler argumentos ---
if paramCount() < 1:
  echo "Uso: ", getAppFilename(), " <extensão>"
  quit(1)

# Obter a extensão (sem ponto)
let extArg = paramStr(1).toLowerAscii()

# Pasta de destino
let destino = getCurrentDir() / (extArg & "_files")

# Criar pasta se não existir
proc createDirIfNotExists(dir: string) =
  if not dirExists(dir):
    createDir(dir)
    let temp_str: string = fmt"Folder created: {dir}"
    stdout.styledWriteLine(fgGreen, temp_str)


var existeFicheiro = false
# Percorrer diretório atual
for entry in walkDir(getCurrentDir()):
  if entry.kind == pcFile:
    let
      fext  = splitFile(entry.path).ext.toLowerAscii()  # extensão com ponto
      fname = splitFile(entry.path).name                # nome sem extensão
    # Verificar se a extensão corresponde
    if fext == "." & extArg:
      createDirIfNotExists(destino)
      existeFicheiro = true
      let novoCaminho = destino / (fname & fext)
      moveFile(entry.path, novoCaminho)
      #echo "Movido: ", entry.path, " -> ", novoCaminho
      let output: string = fmt"Moved:  {splitFile(entry.path).name}{splitFile(entry.path).ext} ->  {extractFilename(splitPath(novoCaminho).head)} / {extractFilename(novoCaminho)}"
      stdout.styledWriteLine(fgCyan, output)

if not existeFicheiro:
  echo "Nenhum ficheiro com extensão .", extArg, " encontrado no diretório atual."
  quit(0)