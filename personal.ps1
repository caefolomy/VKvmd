# Не забудьте в первом шаге заменить заглушку `"doc$id_собеседника"`, например `"doc$1"`.
# 1. Находение и оставление в документе строки содержащей только документы от собеседника: 
Get-Content messages.txt | Where-Object { $_ -match "doc$id_собеседника" } | Set-Content doc_messages.txt

# 2. Находение и оставление в документе строки содержащей только документы от собеседника:
Get-Content doc_messages.txt |
    Where-Object { $_ -match 'https:.*\.ogg' } |
    ForEach-Object { $_ -replace '.*?(https:.*?\.ogg).*', '$1' } |
    Set-Content voice_messages.txt

# 3. Находение и оставление в документе только URL-ссылки голосовых сообщений от собеседника:
Get-Content voice_messages.txt | ForEach-Object {
    $filename = [System.IO.Path]::GetFileName($_)
    Invoke-WebRequest -Uri $_ -OutFile $filename
}

# 4. Загрузка .ogg файлов:
$downloadFolder = ".\voice_messages"
if (-not (Test-Path $downloadFolder)) { New-Item -ItemType Directory -Path $downloadFolder }
Get-Content voice_messages.txt | ForEach-Object {
    $filename = [System.IO.Path]::GetFileName($_)
    $outputPath = Join-Path -Path $downloadFolder -ChildPath $filename
    Invoke-WebRequest -Uri $_ -OutFile $outputPath
}

# 5. [ОПЦИАЛЬНЬНО] Удаление .txt файлов из папки:
Remove-Item -Path *.txt -ErrorAction SilentlyContinue
