import sys
import logging

logging.basicConfig(stream=sys.stderr)
sys.path.insert(0,"/var/www/html/resources/")

from app import app as application