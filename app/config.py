# app/config.py
import os
import logging

class Config:
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'you-will-never-guess'

# Logging configuration
LOG_FILE = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), 'nextrade.log')
logging.basicConfig(
    level=logging.DEBUG,
    format='%(asctime)s [%(levelname)s] %(message)s',
    handlers=[
        logging.FileHandler(LOG_FILE),
        logging.StreamHandler()
    ]
)
