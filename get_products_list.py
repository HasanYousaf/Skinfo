from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
import time
import os
import math

opts = Options()
opts.add_argument("user-agent=['Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.51 Safari/537.36']")
opts.add_argument("--disable-notifications")
driver = webdriver.Chrome(options=opts)
driver.maximize_window()

brands = open('sephora_brand_pages.txt', 'r').readlines()

product_xpath = '//div/a[@class="css-klx76"]'

def window_scroll(x):
	return f"window.scrollTo(0, document.body.scrollHeight*{x})"

def scrape_brandpage_v1(url, num_products):	
	if url:
		driver.implicitly_wait(2)
		driver.get(url)	
	if (num_products > 12) and (num_products <= 25):
		driver.execute_script(window_scroll(0.60))
		time.sleep(2)
	if (num_products > 25) and (num_products <= 36):
		driver.execute_script(window_scroll(0.6))
		time.sleep(2)
		driver.execute_script(window_scroll(0.4))
		time.sleep(2)	
		driver.execute_script(window_scroll(0.8))
		time.sleep(2)
	if (num_products > 36):
		nproducts_initial = len(driver.find_elements(By.XPATH, product_xpath))
		if nproducts_initial <= 36:
			driver.execute_script("arguments[0].scrollIntoView()", \
				driver.find_elements(By.XPATH, product_xpath)[0])
			time.sleep(2)
			nproducts_final = len(driver.find_elements(By.XPATH, product_xpath))
			if nproducts_initial == nproducts_final:
				try:
					driver.find_elements(By.XPATH, product_xpath)[0]
					time.sleep(1)
					driver.find_elements(By.XPATH, product_xpath)[0].\
						send_keys(Keys.PAGE_DOWN)
				except:
					time.sleep(2)
					driver.find_elements(By.XPATH, product_xpath)[0]
					time.sleep(1)
					driver.find_elements(By.XPATH, product_xpath)[0].\
						send_keys(Keys.PAGE_DOWN)
		time.sleep(1)						
		driver.execute_script("arguments[0].scrollIntoView()", \
			driver.find_elements(By.XPATH, product_xpath)[0])
		time.sleep(2)
		driver.execute_script("arguments[0].scrollIntoView()", \
			driver.find_elements(By.XPATH, product_xpath)[0])		
		time.sleep(3)
		driver.execute_script(window_scroll(0.6))
		time.sleep(2)
		driver.execute_script("arguments[0].scrollIntoView()", \
			driver.find_elements(By.XPATH, product_xpath)[0])
		time.sleep(2)
	try:
		products = driver.find_elements(By.XPATH, product_xpath)
		product_urls = [product.get_attribute('href') for product in products]
	except:
		products = driver.find_elements(By.XPATH, product_xpath)
		product_urls = [product.get_attribute('href') for product in products]
	print(product_urls)
	return product_urls
	
def scrape_brandpage_v2():
	nproducts_initial = len(driver.find_elements(By.XPATH, product_xpath))
	driver.execute_script("arguments[0].scrollIntoView()", driver.\
		find_elements(By.XPATH, product_xpath)[0])
	time.sleep(2)
	nproducts_final = len(driver.find_elements(By.XPATH, product_xpath))
	if nproducts_initial == nproducts_final:
		driver.find_elements(By.XPATH, product_xpath)[0]
		time.sleep(1)
		time.sleep(3)
		driver.execute_script(window_scroll(0.8))
		time.sleep(3)
		nproducts  = len(driver.find_elements(By.XPATH, product_xpath))
		if nproducts == nproducts_final:
			driver.find_elements(By.XPATH, product_xpath)[5].\
				send_keys(Keys.PAGE_DOWN)
			time.sleep(3)
			nproducts  = len(driver.find_elements(By.XPATH, product_xpath))
			driver.find_elements(By.XPATH, product_xpath)[0]
			time.sleep(1)
	driver.execute_script(window_scroll(0.2))
	time.sleep(2)
	driver.execute_script(window_scroll(0.5))
	time.sleep(3)
	driver.execute_script(window_scroll(0.8))
	time.sleep(1)
	driver.execute_script(window_scroll(0.63))
	time.sleep(3)
	try:
		products = driver.find_elements(By.XPATH, product_xpath)
		product_urls = [product.get_attribute('href') for product in products]
	except:
		products = driver.find_elements(By.XPATH, product_xpath)
		product_urls = [product.get_attribute('href') for product in products]
	print(product_urls)
	return product_urls

def scrape_brandpage_v3():
	nproducts_initial = len(driver.find_elements(By.XPATH, product_xpath))
	driver.execute_script("arguments[0].scrollIntoView()", \
		driver.find_elements(By.XPATH, product_xpath)[0])
	time.sleep(2)
	nproducts_final = len(driver.find_elements(By.XPATH, product_xpath))
	if nproducts_initial == nproducts_final:
		driver.find_elements(By.XPATH, product_xpath)[0]
		time.sleep(1)
		driver.execute_script(window_scroll(0.8))
		time.sleep(3)
		nproducts  = len(driver.find_elements(By.XPATH, product_xpath))
	time.sleep(2)
	driver.execute_script(window_scroll(0.2))
	time.sleep(2)
	driver.execute_script(window_scroll(0.5))
	time.sleep(3)
	driver.execute_script(window_scroll(0.8))
	time.sleep(1)
	driver.execute_script(window_scroll(0.63))
	time.sleep(3)
	try:
		products = driver.find_elements(By.XPATH, product_xpath)
		product_urls = [product.get_attribute('href') for product in products]
	except:
		products = driver.find_elements(By.XPATH, product_xpath)
		product_urls = [product.get_attribute('href') for product in products]
	print(product_urls)
	return product_urls

def change_page(brand, currentPage):
	brand = brand + "?currentPage=" + str(currentPage + 1)
	return brand
	
def num_pages_2(brand, num_tot_products, method):
	brand_urls = scrape_brandpage_v1(brand, 60)
	brand = brand + "?currentPage=" + str(2)
	if method == 1:
		brand_urls.extend(scrape_brandpage_v1(brand, num_tot_products-60))
	if method == 2:
		brand_urls.extend(scrape_brandpage_v2())
	return brand_urls

def getBrand(brand, number):
    if number <=1:
        return brand
    else:
        brand = brand + '?currentPage=' + str(number)
        return brand

if os.path.isfile('index.txt') and os.path.isfile('sephora_product_urls.txt'):
	index = int(open('index.txt').read())
	f = open('sephora_product_urls.txt', 'a')
else:
	index = 0
	f = open('sephora_product_urls.txt', 'w')

try:
	for i, brand in enumerate(brands[index:]):
		driver.implicitly_wait(2)
		driver.get(brand)
		try:
			num_tot_products = int(driver.find_element(By.XPATH, '//p'+\
				'[@data-at="number_of_products"]').text.split()[0])
			print(num_tot_products)
		except:
			num_tot_products = 0
			print(num_tot_products)
			continue
		if num_tot_products <= 60:
			brand_urls = scrape_brandpage_v1(brand, num_tot_products)
			print("num_tot_products <=60")
		elif num_tot_products <= 120:
			try:
				brand_urls = num_pages_2(brand, num_tot_products, 1)
				print("num_tot_products <=120")
			except:
				num_pages_2(brand, num_tot_products, 2)
		elif num_tot_products <= 180:
			brand_urls = num_pages_2(brand, num_tot_products, 1)
			brand = brand + '?currentPage=3'
			brand_urls.extend(scrape_brandpage_v1(brand, num_tot_products))
			print("num_tot_products <=180")
		else:
			num_pages = math.ceil(num_tot_products/60)
			num_last_page = num_tot_products % 60
			if num_last_page == 0:
				num_last_page = 60
			brand_urls = num_pages_2(brand, 120, 1)
			for _ in range(num_pages):
				if _ < 3:
					continue
				else:
					brand_urls.extend(scrape_brandpage_v1(getBrand(brand, _), num_tot_products))

		for url in brand_urls:
			f.write(url+'\n')
except Exception as e:
	print(e)
	f.close()
	new_index = i+index
	open('index.txt', 'w').write('%d' %(i+index))

quit()



