#!/bin/bash

# this bash code was made by ATOUI Rayane to automate the operation of creating Linux from scratch with the help of LFS book v12 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

bash ./_colors_in_consol.sh
cd ./languages
# select_lang found in ./_methodes
bash ./_languages_man.sh
source ./_methodes.sh
source $SHARED_FILE
cd ..

#Choosing language
select_lang
bash $SELECTED_LANG
source $SHARED_FILE
echo -e "$DONE"


# other methodes
source ./_util_methodes.sh

