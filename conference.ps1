# 0. ВНИМАНИЕ! Не копировать этап #0 при первом использовании! (не забывайте указывать id собеседника):
$id_собеседника = "[id собеседника]"

$combinedContent | Where-Object { $_ -match "doc$id_собеседника" } | Set-Content doc_messages.txt

$voiceMessages = Get-Content doc_messages.txt | Where-Object { $_ -match 'https:.*\.ogg' } | ForEach-Object {
    $url = $_ -replace '.*?(https:.*?\.ogg).*', '$1'
    $url
}
$voiceMessages | Set-Content voice_messages.txt

$fileWithPath = "$path\voice_messages.txt"
$downloadFolder = "$path"
$voiceUrls = Get-Content $fileWithPath
$voiceUrls | ForEach-Object {
    $url = $_
    $filename = [System.IO.Path]::GetFileName($url)
    $outputPath = Join-Path -Path $downloadFolder -ChildPath $filename
    Invoke-WebRequest -Uri $url -OutFile $outputPath
}

Remove-Item -Path doc_messages.txt, voice_messages.txt

# 1. Указывается путь к папке с сообщениями, необходимо указать вручную
$path = "[путь_к_каталогу]"
cd $path

# 2. Необходимо также вручную задать цифры id желаемого участника беседы
$id_собеседника = "[id собеседника]"

# 3. Переименовываются все файлы .html в .txt:
Get-ChildItem -Filter *.html | ForEach-Object {
    $newFileName = [System.IO.Path]::ChangeExtension($_.FullName, "txt")
    Move-Item $_.FullName $newFileName
}

# 4. Объединяются все .txt файлы в один и удаляются оставшиеся .txt файлы:
$filesToCombine = Get-ChildItem -Filter *.txt | Where-Object { $_.Name -ne "messages.txt" }
$combinedContent = Get-Content $filesToCombine.FullName
$combinedContent | Add-Content messages.txt
$filesToCombine | Remove-Item

# 5. Находение и оставление в документе строки содержащей только документы от собеседника:
$combinedContent | Where-Object { $_ -match "doc$id_собеседника" } | Set-Content doc_messages.txt

# 6. Находение и оставление в документе только URL-ссылки голосовых сообщений от собеседника:
$voiceMessages = Get-Content doc_messages.txt | Where-Object { $_ -match 'https:.*\.ogg' } | ForEach-Object {
    $url = $_ -replace '.*?(https:.*?\.ogg).*', '$1'
    $url
}
$voiceMessages | Set-Content voice_messages.txt

# 7. Загрузка .ogg файлов:
$fileWithPath = "$path\voice_messages.txt"
$downloadFolder = "$path"
$voiceUrls = Get-Content $fileWithPath
$voiceUrls | ForEach-Object {
    $url = $_
    $filename = [System.IO.Path]::GetFileName($url)
    $outputPath = Join-Path -Path $downloadFolder -ChildPath $filename
    Invoke-WebRequest -Uri $url -OutFile $outputPath
}

# 8. Удаление ненужных .txt файлов
Remove-Item -Path doc_messages.txt, voice_messages.txt