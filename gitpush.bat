#!/bin/bash

# Git dizinine gitmek (Opsiyonel)
# cd /path/to/your/git/repository

# Tüm değişiklikleri ekler
git add .

# "update" mesajı ile commit yapar
git commit -m "update"

# Değişiklikleri remote repository'e push eder
git push

echo "Değişiklikler başarıyla push edildi."