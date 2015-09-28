#!/bin/bash
# 20111207 e.blindauer version initiale
# 20111216 e.blindauer prise en charge encodage
# 20141003 e.blindauer mise en place ciblage et fichier de conf


# Ce script prend en parametre un fichier de conf
[ $# -eq 1 ] || echo "il manque un parametre: le fichier de conf"

source $1


export LC_ALL=fr_FR.UTF-8
NB=$(/usr/bin/rt ls -i "$Query" 2>/dev/null)
if ! [ $? -eq 0 ]; then
	[ QUIET -eq 0 ] && echo "erreur query, on sort"
	exit 1
fi


for i in $NB; do
	NUMERO=$(echo $i|cut -f2 -d'/')
	NEW_TICKET=0
	[ ! -d $DATADIR/$i ] && NEW_TICKET=1
	[ $NEW_TICKET -eq 1 ] && mkdir  -p $DATADIR/$i
	[ $INIT -eq 0 ] && [ $NEW_TICKET -eq 1 ] && ( echo -e "Une nouvelle demande vient d'etre émise\n\n" ;/usr/bin/rt show -l -f id,requestors,creator,created,subject $i 2>/dev/null ;echo -e "\nLien RT: https://rt.unistra.fr/rt/Ticket/Display.html?id=$NUMERO\n\n") |nail -r $FROMMAIL -s "$SUBJECTMAIL" $TOMAIL
done

exit 0
