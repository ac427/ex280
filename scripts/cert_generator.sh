display_usage() { 
  echo "give the fqdn of the hostname as arg" 
  echo -e "\nUsage: $0 [arguments] \n" 
} 

if [  $# -eq 0 ] 
then 
  display_usage
  exit 1
fi 

mkdir -p $1 
cd $1
echo creating CA
openssl genrsa -des3  -passout pass:testing -out rootCA.key 4096
openssl req -x509 -new -passin pass:testing -nodes -key rootCA.key -sha256 -days 1024 -subj "/C=US/ST=CA/O=MyOrg, Inc./CN=crc.example.com" -out rootCA.crt

echo 'generating key for the doamin $1'
openssl genrsa -out $1.key 2048
echo 'creating csr'
openssl req -new -sha256 -key $1.key -subj "/C=US/ST=CA/O=MyOrg, Inc./CN=$1" -out $1.csr
echo 'signing the cert using the CA credentials'
openssl x509 -req -in $1.csr -CA rootCA.crt -CAkey rootCA.key -passin pass:testing -CAcreateserial -out $1.crt -days 500 -sha256
