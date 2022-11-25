import os


class Config:
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'you-will-never-guess'
    SQLALCHEMY_DATABASE_URI = 'postgresql://postgres:VupsenPupsen228@localhost:5431/postgres'
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    DEBUG = True
