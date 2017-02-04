#!/bin/sh

FNAME=""
THOLD_VAL=0
COUNT_VAL=0
COUNT_GOOD=0
THOLD_GOOD=0

function usage
{
    echo "usage: analyse_executions.sh [[[--file filename ] [--treshold treshval ]] | [--help]]"
}


while [ "$1" != "" ]; do
    case "$1" in
        -f | --file )           shift
                                FNAME=$1
                                ;;
        -t | --treshold )       shift
                                THOLD_GOOD=$1
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1;
    esac
    shift
done

if [ ! -f $FNAME ]
then
    echo "File not exist!"
    exit 1
fi

COUNT_VAL=`tail -n +2 "$FNAME" | wc -l`
echo "number of executed job: $COUNT_VAL"

COUNT_GOOD=`tail -n +2 "$FNAME" | awk '{print $7}' | grep 0 | wc -l`
echo "number of successed job: $COUNT_GOOD"

echo "number of failed job: $(($COUNT_VAL-$COUNT_GOOD))"

THOLD_VAL=$((100*$COUNT_GOOD/$COUNT_VAL))
echo "threshold: $THOLD_VAL% successed job"

if [ $THOLD_VAL -lt $THOLD_GOOD ]
then
    exit 1
fi


