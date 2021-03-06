#Checks if files have been modified
#Params source/file, bin/file
replacemodified()
{
  if [ ! -e "$2" ] || [ "$1" -nt "$2" ]; then
    cp "$1" "$2";
  fi
  return 0
}
#Checks if files to merge, checks modified
#Params shared/file, browser/_file, bin/file
merge()
{
  if [ -f "$2" ]; then
    if [ ! -e "$3" ] || [ "$1" -nt "$3" ] || [ "$2" -nt "$3" ]; then
      cat "$1" "$2" > "$3";
    fi
  else
    replacemodified "$1" "$3";
  fi
 return 0
}

if [ "$1" != "chrome" ] && [ "$1" != "firefox" ]; then
  echo "Not a valid extension";
  exit;
fi

echo "copying shared files into $1";

#pack images
[ -d bin/$1/images ] || mkdir -p bin/$1/images;
for i in $( ls shared/images); do
  replacemodified shared/images/$i bin/$1/images/;
done
#browser specific images
for i in $( ls $1/images); do
  replacemodified $1/images/$i bin/$1/images/;
done

#pack libraries
[ -d bin/$1/lib ] || mkdir -p bin/$1/lib;
for i in $( ls shared/lib); do
  replacemodified shared/lib/$i bin/$1/lib/;
done
#browser specific images
for i in $( ls shared/lib); do
  replacemodified $1/lib/$i bin/$1/lib/;
done

#combine and pack styles (css)
[ -d bin/$1/styles ] || mkdir -p bin/$1/styles;
for i in $( ls shared/styles); do
  merge shared/styles/$i $1/styles/_$i bin/$1/styles/$i;
done
#browser specific styles
for i in $( ls $1/styles); do
  if [[ $i != _* ]]; then
    replacemodified $1/styles/$i bin/$1/styles/;
  fi
done

#combine and pack scripts
[ -d bin/$1/scripts ] || mkdir -p bin/$1/scripts;
for i in $( ls shared/scripts); do
  merge shared/scripts/$i $1/scripts/_$i bin/$1/scripts/$i;
done
#browser specific scripts
for i in $( ls $1/scripts); do
  if [[ $i != _* ]]; then
    replacemodified $1/scripts/$i bin/$1/scripts/;
  fi
done

#pack any other browser exclusive files
for i in $( find $1 -maxdepth 1 -type f ); do
  replacemodified $i bin/$1/;
done

exit 0
