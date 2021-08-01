#!/bin/bash 

# e.g. bash download_data.sh [directory to save data to]

script_dir=`dirname "$0"`
base=$script_dir/../..
scripts=$base/scripts

data_dir=$base/$1

mkdir -p $data_dir

cd $data_dir
mkdir -p in_domain out_domain

cd in_domain && mkdir -p full europarl europarl_5k europarl_10k europarl_20k europarl_40k europarl_80k && cd ..
cd out_domain && mkdir -p law medical religion && cd ..

cd in_domain/europarl
wget https://opus.nlpl.eu/download.php?f=Europarl/v8/moses/en-fi.txt.zip -O europarl.zip 
unzip europarl.zip 
rm europarl.zip
cd ../..

cd out_domain/law 
wget https://opus.nlpl.eu/download.php?f=JRC-Acquis/en-fi.txt.zip -O law.zip 
unzip law.zip 
rm law.zip 
cd ../..

cd out_domain/medical 
wget https://opus.nlpl.eu/download.php?f=EMEA/v3/moses/en-fi.txt.zip -O medical.zip 
unzip medical.zip 
rm medical.zip
cd ../..

cd out_domain/religion
wget https://opus.nlpl.eu/download.php?f=bible-uedin/v1/moses/en-fi.txt.zip -O religion.zip 
unzip religion.zip
rm religion.zip 
cd ../../..

echo ""
echo "Creating datasets..."
python sample_data.py $data_dir 

cd $data_dir/in_domain/europarl && rm -rf Europarl.en-fi.en && rm -rf Europarl.en-fi.fi && rm -rf Europarl.en-fi.xml && rm -rf LICENSE && rm -rf README && cd ../../../
cd $data_dir/out_domain/law && rm -rf JRC-Acquis.en-fi.en && rm -rf JRC-Acquis.en-fi.fi && rm -rf JRC-Acquis.en-fi.xml && rm -rf LICENSE && rm -rf README && cd ../../../
cd $data_dir/out_domain/medical && rm -rf EMEA.en-fi.en && rm -rf EMEA.en-fi.fi && rm -rf README && cd ../../../
cd $data_dir/out_domain/religion && rm -rf bible-uedin.en-fi.en && rm -rf bible-uedin.en-fi.fi && rm -rf bible-uedin.en-fi.xml && rm -rf LICENSE && rm -rf README

echo "Done."
