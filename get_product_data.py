from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.keys import Keys
from selenium.common.exceptions import NoSuchElementException
import time
import random
import re
import os
import csv
import math

opts = Options()
opts.add_argument("user-agent=['Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.51 Safari/537.36']")
opts.add_argument("--disable-notifications")

driver = webdriver.Chrome(options=opts)
driver.maximize_window()

product_urls = open('sephora_product_urls.txt', 'r').readlines()

columns = ['name', 'brand', 'family', 'genus', 'species', 'price','ingredients']
column_dict = dict(zip(columns, columns))

if os.path.isfile(f'index.txt') and os.path.isfile(f'products.csv'):
	index = int(open('index.txt').read())
	csv_file =  open(f'products.csv', 'a', encoding='utf-8', newline='')
	writer = csv.DictWriter(csv_file, fieldnames = columns)
	product_urls = product_urls[index:]
else:
	index = 0
	csv_file =  open(f'products.csv', 'w', encoding='utf-8', newline='')
	writer = csv.DictWriter(csv_file, fieldnames = columns)
	writer.writerow(column_dict)	    


unwanted_products = ['Mini Size', 'Value & Gift Sets', 'Facial Rollers', 
	'Brushes & Applicators', 'Brushes & Combs', 'Tools & Brushes', 'False Eyelashes', 'Rollerballs & Travel Size', 
	'Candles & Home Scents', 'Beauty Supplements','High Tech Tools', 'Beauty Tools', 
	'Lip Sets', 'Face Sets', 'Eye Sets', 'Makeup Bags & Travel Accessories',
	'Tweezers & Eyebrow Tools', 'Blotting Papers', 'Hair Tools', 'Tools']

    
def close_prompt():
    continue_shopping.click()
    
def show_ingredients():
    ingredients_tab = driver.find_element(By.XPATH, '/html/body/div[2]/main/div[1]/button[1]')
    ingredients_tab.click()

def window_scroll(x):
	return f"window.scrollTo(0, document.body.scrollHeight*{x})"

try:
	for i, url in enumerate(product_urls):
		print(i+index) 
		product_dict = {}
		driver.implicitly_wait(5)
		driver.get(url)
		time.sleep(5)
		product_type = driver.find_elements(By.XPATH, '//nav[@aria-label="Br'+\
			'eadcrumb"]//a')
		if len(product_type) < 3: continue

		product_type = [val.text for val in product_type]

		if (product_type[1] in unwanted_products) or \
			(product_type[2] in unwanted_products):
			continue

		brand_name = driver.find_elements(By.XPATH, '//a[@data-at="brand_name"]')
		product_name = driver.find_elements(By.XPATH, '//span[@data-at="product_name"]')
		clean_at_sephora = 'Acrylates, Aluminum Salts, Animal Musks/Fats/Oils'

		
		product_dict['family'] = product_type[0]
		product_dict['genus'] = product_type[1]
		product_dict['species'] = product_type[2]
		product_dict['name'] = product_name[0].text
		product_dict['brand'] = brand_name[0].text
		print(brand_name[0].text)
		print(product_name[0].text)
				
		try:
			product_dict['price'] = driver.find_elements(By.XPATH, '//p[@data-comp="Price "]//b')[0].text 
			print(product_dict['price'])
		except:
			product_dict['price'] = driver.find_element(By.XPATH, '//div[@dat'+\
				'a-comp="Price Box "]/span[1]').text	
		
		try:
			continue_shopping = driver.find_element(By.XPATH, '/html/body/div[6]/div/div/div[2]/div/div/button')
			continue_shopping.click()
			time.sleep(2)
			show_ingredients()
		except:
			driver.execute_script(window_scroll(-0.1))
			show_ingredients()
		
		try:
			raw_ingredients = driver.find_elements(By.XPATH, '//div[@id="ingredients"]/div/div')[0].text
			if 'Palettes' in product_dict['species'] or 'Duo' in product_dict['name']:
				Ingredients = raw_ingredients.split("\n")
				product_dict['ingredients'] = ""
				for i in range(len(Ingredients)):
					if Ingredients[i].startswith(clean_at_sephora) or 'Clean at Sephora products' in Ingredients[i]:
						break
					elif Ingredients[i] != "":
						product_dict['ingredients'] += ''.join(Ingredients[i])
					else:
						continue
			else:	
				Ingredients = raw_ingredients.split("\n\n", 3)
				for i in range(4):
					if Ingredients[i].startswith('-'):
						continue
					else:
						product_dict['ingredients'] = ''.join(Ingredients[i])
						break
   
		except IndexError:
			try:
				raw_ingredients = driver.find_elements(By.XPATH, '//div[@id="ingredients"]/div/div')[0].text
				product_dict['ingredients'] = ""
				Ingredients = raw_ingredients.split("\n")
				for i in range(len(Ingredients)):
					if Ingredients[i] != "":
						product_dict['ingredients'] += ''.join(Ingredients[i])
			except:
				product_dict['ingredients'] = "N/A"
   
		print(product_dict['ingredients'])
		
		writer.writerow(product_dict)
		time.sleep(3)
except Exception as e:
	print(url)
	print(e)
	open('index.txt', 'w').write('%d' %(i+index))
	csv_file.close()
	driver.close()
	time.sleep(2)
	quit()

driver.close()
quit()

