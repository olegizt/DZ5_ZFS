#!/bin/bash

"\e[0;37;42m OK! IP-адрес успешно настроен \e[0m"

printf "\e[0;37;42mВыводим список всех дисков, которые есть в виртуальной машине
lsblk

printf "\e[0;37;42m --- Создаём пул из 4-х пар дисков в режиме RAID 1 ---\e[0m"
sudo zpool create oleg1 mirror /dev/sdb /dev/sdc
sudo zpool create oleg2 mirror /dev/sdd /dev/sde
sudo zpool create oleg3 mirror /dev/sdf /dev/sdg
sudo zpool create oleg4 mirror /dev/sdh /dev/sdi

printf "\e[0;37;42m --- Выводим информацию о пулах ---\e[0m"
sudo zpool list

printf "\e[0;37;42m --- Выводим информацию о каждом диске ---\e[0m"
sudo zpool status

printf "\e[0;37;42m --- Применим разные алгоритмы сжатия для каждого пула ---\e[0m"
sudo zfs set compression=lzjb oleg1
sudo zfs set compression=lz4 oleg2
sudo zfs set compression=gzip-9 oleg3
sudo zfs set compression=zle oleg4

printf "\e[0;37;42m --- Проверим, что все пулы имеют разные методы сжатия ---\e[0m"
sudo zfs get all | grep compression

printf "\e[0;37;42m --- Скачаем один и тот же текстовый файл во все пулы ---\e[0m"
for i in {1..4}; do sudo wget -P /oleg$i https://gutenberg.org/cache/epub/2600/pg2600.converter.log; done

printf "\e[0;37;42mПроверим, что файл был скачан во все пулы ---\e[0m"
sudo ls -l /oleg*

printf "\e[0;37;42m --- Проверим, сколько места занимает один и тот же файл в разных пулах ---\e[0m"
sudo zfs list

printf "\e[0;37;42m --- ... и проверим степень сжатия файлов ---\e[0m"
sudo zfs get all | grep compressratio | grep -v ref

printf "\e[0;37;42m --- Скачиваем лабораторный архив в домашний каталог и разархивируем его ---\e[0m"
wget -O archive.tar.gz --no-check-certificate 'https://drive.usercontent.google.com/download?id=1MvrcEp-WgAQe57aDEzxSRalPAwbNN1Bb&export=download'
tar -xzvf archive.tar.gz

printf "\e[0;37;42m --- Проверим, возможно ли импортировать данный каталог в пул ---\e[0m"
sudo zpool import -d zpoolexport/

printf "\e[0;37;42m --- Импортируем данный пула к нам в ОС и посмотрим статус ---\e[0m"
sudo zpool import -d zpoolexport/ oleg
sudo zpool status

printf "\e[0;37;42m --- Выведем все параметры импортированного пула ---\e[0m"
sudo zfs get all otus

printf "\e[0;37;42m --- ... его размер ---\e[0m"
sudo zfs get available oleg

printf "\e[0;37;42m --- ... тип ---\e[0m"
sudo zfs get readonly oleg

printf "\e[0;37;42m --- ... значение recordsize ---\e[0m"
sudo zfs get recordsize oleg

printf "\e[0;37;42m --- ... тип сжатия ---\e[0m"
sudo zfs get compression oleg

printf "\e[0;37;42m --- ... тип контрольной суммы ---\e[0m"
sudo zfs get checksum oleg

printf "\e[0;37;42m --- Скачаем файл снэпшота указанный в задании ---\e[0m"
wget -O otus_task2.file --no-check-certificate https://drive.usercontent.google.com/download?id=1wgxjih8YZ-cqLqaZVa0lA3h3Y029c3oI&export=download

printf "\e[0;37;42m --- Восстановим файловую систему из снапшота в пул oleg ---\e[0m"
sudo zfs receive oleg/test@today < otus_task2.file

printf "\e[0;37;42m --- Найдём в каталоге /oleg/test файл с именем secret_message ---\e[0m"
sudo find /oleg/test -name "secret_message"

printf "\e[0;37;42m --- Просмотрим содержимое найденного файла ---\e[0m"
sudo cat /oleg/test/task1/file_mess/secret_message

printf "\e[0;37;41m --- Задание выполнено ---\e[0m"
