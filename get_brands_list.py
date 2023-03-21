from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By

opts = Options()
opts.add_argument("user-agent=['Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.51 Safari/537.36']")
opts.add_argument("--disable-notifications")
driver = webdriver.Chrome(options=opts)

start_url = "https://www.sephora.com/brands-list"
driver.get(start_url)

brands = driver.find_elements(By.XPATH, '//div//ul/li/a')
brands = [a.get_attribute('href')+'/all' for a in brands]

with open('sephora_brand_pages.txt', 'w') as f:
	for url in brands:
		f.write(url+'\n')

driver.close()
