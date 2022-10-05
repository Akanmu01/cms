# build_files.sh
pip install -r requirements.txt
python3.9 manage.py collectstatic
python3.9 manage.py makemigrations
python3.9 manage.py migrate
# python3.9 manage.py createsuperuser --username test1 --password 123321 --noinput --email 'blank@email.com'
