
"""
========================================================================================

@author: Angelo

●指定Chrome主程式路徑
●指定chromedriver路徑
●chrome prefs(不要記錄密碼)
========================================================================================
"""

import time
from selenium import webdriver
from selenium.webdriver.chrome.options import Options

tupleChromeSetting = ("D:/GoogleChromePortable64/App/Chrome-bin/chrome.exe", \
                      "F:/chromedriver.exe", \
                      "--user-data-dir=F:/【MetaData】/userDataDire")
prefs = {"credentials_enable_service":False}

chromebinaryPath = tupleChromeSetting[0]
chromedriverPath = tupleChromeSetting[1]
argsUserData = tupleChromeSetting[2]

options = Options()

#指定Chrome主程式路徑(利用Option方式)
options.binary_location=chromebinaryPath
#chrome preferences
options.add_experimental_option("prefs",prefs)
options.add_argument(argsUserData)

#啟動webdriver並啟動Chrome
driver = webdriver.Chrome(options=options,executable_path=chromedriverPath,)
driver.get("https://www.netflix.com/tw/login")
#driver.minimize_window()

driver.find_element_by_xpath("//input[@name='userLoginId']").send_keys("5678")
driver.find_element_by_xpath("//input[@name='password']").send_keys("1234")
driver.find_element_by_xpath("//*[@id='appMountPoint']/div/div[3]/div/div/div[1]/form/div[3]/div/label").click()
driver.execute_script("return document.getElementById('id_password_toggle').remove();","")

time.sleep(5)
driver.maximize_window()
time.sleep(5)


#關掉chromedriver and 瀏覽器
#driver.quit()




