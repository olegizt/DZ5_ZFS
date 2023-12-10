#!/bin/bash

printf "\e[0;37;42m --- Выводим список всех дисков, которые есть в виртуальной машине ---\e[0m\n"
lsblk

printf "\n\e[0;37;42m --- Создаём пул из 4-х пар дисков в режиме RAID 1 ---\e[0m\n"
sudo zpool create oleg1 mirror /dev/sdb /dev/sdc
sudo zpool create oleg2 mirror /dev/sdd /dev/sde
sudo zpool create oleg3 mirror /dev/sdf /dev/sdg
sudo zpool create oleg4 mirror /dev/sdh /dev/sdi

printf "\n\e[0;37;42m --- Выводим информацию о пулах ---\e[0m\n"
sudo zpool list

printf "\n\e[0;37;42m --- Выводим информацию о каждом диске ---\e[0m\n"
sudo zpool status

printf "\n\e[0;37;42m --- Применим разные алгоритмы сжатия для каждого пула ---\e[0m\n"
sudo zfs set compression=lzjb oleg1
sudo zfs set compression=lz4 oleg2
sudo zfs set compression=gzip-9 oleg3
sudo zfs set compression=zle oleg4

printf "\n\e[0;37;42m --- Проверим, что все пулы имеют разные методы сжатия ---\e[0m\n"
sudo zfs get all | grep compression

printf "\n\e[0;37;42m --- Скачаем один и тот же текстовый файл во все пулы ---\e[0m\n"
for i in {1..4}; do sudo wget -P /oleg$i https://gutenberg.org/cache/epub/2600/pg2600.converter.log; done

printf "\n\e[0;37;42mПроверим, что файл был скачан во все пулы ---\e[0m\n"
sudo ls -l /oleg*

printf "\n\e[0;37;42m --- Проверим, сколько места занимает один и тот же файл в разных пулах ---\e[0m\n"
sudo zfs list

printf "\n\e[0;37;42m --- ... и проверим степень сжатия файлов ---\e[0m\n"
sudo zfs get all | grep compressratio | grep -v ref

printf "\n\e[0;37;42m --- Скачиваем лабораторный архив в домашний каталог и разархивируем его ---\e[0m\n"
wget -O archive.tar.gz --no-check-certificate 'https://drive.usercontent.google.com/download?id=1MvrcEp-WgAQe57aDEzxSRalPAwbNN1Bb&export=download'
tar -xzvf archive.tar.gz

printf "\n\e[0;37;42m --- Проверим, возможно ли импортировать данный каталог в пул ---\e[0m\n"
sudo zpool import -d zpoolexport/

printf "\n\e[0;37;42m --- Импортируем данный пула к нам в ОС и посмотрим статус ---\e[0m\n"
sudo zpool import -d zpoolexport/ otus
sudo zpool status

printf "\n\e[0;37;42m --- Выведем все параметры импортированного пула ---\e[0m\n"
sudo zfs get all otus

printf "\n\e[0;37;42m --- ... его размер ---\e[0m\n"
sudo zfs get available otus

printf "\n\e[0;37;42m --- ... тип ---\e[0m\n"
sudo zfs get readonly otus

printf "\n\e[0;37;42m --- ... значение recordsize ---\e[0m\n"
sudo zfs get recordsize otus

printf "\n\e[0;37;42m --- ... тип сжатия ---\e[0m\n"
sudo zfs get compression otus

printf "\n\e[0;37;42m --- ... тип контрольной суммы ---\e[0m\n"
sudo zfs get checksum otus

printf "\n\e[0;37;42m --- Скачаем файл снэпшота указанный в задании ---\e[0m\n"
wget -O otus_task2.file --no-check-certificate https://drive.usercontent.google.com/download?id=1wgxjih8YZ-cqLqaZVa0lA3h3Y029c3oI&export=download

printf "\n\e[0;37;42m --- Восстановим файловую систему из снапшота в пул oleg ---\e[0m\n"
sudo zfs receive otus/test@today < otus_task2.file

printf "\n\e[0;37;42m --- Найдём в каталоге /oleg/test файл с именем secret_message ---\e[0m\n"
sudo find /otus/test -name "secret_message"

printf "\n\e[0;37;42m --- Просмотрим содержимое найденного файла ---\e[0m\n"
sudo cat /otus/test/task1/file_mess/secret_message

printf "\n\e[0;37;41m --- Задание выполнено ---\e[0m\n"
