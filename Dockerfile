FROM python:3.10.9

SHELL ["/bin/bash", "-c"]

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONNUNBUFFERED 1

RUN pip install --upgrade pip

WORKDIR /django

COPY . .

RUN pip install -r requirements.txt

CMD python manage.py migrate \
  && python manage.py shell -c "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.filter(username='root').exists() or User.objects.create_superuser('root', 'root@example.com', 'root')" \
  && python manage.py inspectdb \
  && python manage.py collectstatic --no-input \
  && ["gunicorn","-b","0.0.0.0:8001",project.wsgi:application]
