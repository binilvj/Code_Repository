"""
Created on: 2018-10-13
@author: Binil
Purpose:Apply Random forest regression on Boston price data 
"""

from sklearn import datasets as data,linear_model,metrics,ensemble as en
import pandas as pd
import matplotlib.pyplot as plt
#import seaborn as sns
#import numpy as np
#import sklearn as sk


#ds=data.load_boston(return_X_y=True)
ds=data.load_boston()

#print(ds.data.shape)
#print(ds.target.shape)
#print(ds.DESCR)
#print(ds.values)

df=pd.DataFrame(ds.data,columns=['Crime','Zone','Industrial','River','NOX','Rooms','Age','Distance','Radial','Tax','PTRatio','Blk','LStat'])
print(df.shape)
print(df.columns)
#sns.pairplot(df)
#Add column
df1=df.assign(MedVal=pd.Series(ds.target).values)

#print(df1[:5])

#divide data set

train_X=df[:400]
#test=df[200:400]
validate_X=df[400:520]
train_Y=ds.target[:400]
validate_Y=ds.target[400:520]

#train_X=df[['Crime','NOX','Rooms','Distance','Tax','PTRatio','LStat']][:400]
#test=df[200:400]
#validate_X=df[['Crime','NOX','Rooms','Distance','Tax','PTRatio','LStat']][400:520]

#train_Y=ds.target[:400]
#validate_Y=ds.target[400:520]

#regression
#lreg=sk.linear_model.LinearRegression()
#alpha_derived=linear_model.RidgeCV(alphas=(0.00001,0.0001,0.001,0.01,0.1)).fit(train_X,train_Y)
depth=25
est=5000
lreg=en.RandomForestRegressor(n_estimators=est)
lreg.fit(train_X,train_Y)
pred=lreg.predict(validate_X)

mse=metrics.mean_squared_error(validate_Y,pred)

print("Feature importance")
print(lreg.feature_importances_)
#print("Alpha:"+repr(alpha_derived.alpha_))
print("Score"+repr(lreg.score(validate_X,validate_Y)))
#print("Predicted Values")
#print(pred)
#print("Coefficients")
#print(lreg.coef_)

#plot
#plt.scatter(validate_X,validate_Y,alpha=0.5)
#plt.scatter(validate_X,pred,color='red',alpha=0.5)

#plt.suptitle("Ridge regression - Predicted vs. Actual.  Alpha: {0:2.4f} Score: {1:2.4f}\nMSE: {2:3.4f}".format( alpha_derived.alpha_,lreg.score(validate_X,validate_Y),mse),fontsize=16)

plt.suptitle("Random Forest regression - Predicted vs. Actual\nScore: {0:2.4f} Max Depth {1} Estimators: {2} MSE: {3:3.4f}".format( lreg.score(validate_X,validate_Y),depth,est,mse),fontsize=16)

plt.subplot(4, 2,1)
plt.scatter(validate_X['Crime'],validate_Y,alpha=0.5)
plt.scatter(validate_X['Crime'],pred,color='red',alpha=0.5)
plt.xlabel('Crime')
plt.ylabel('Price')

plt.subplot(4,2, 2)
plt.scatter(validate_X['LStat'],validate_Y,alpha=0.5)
plt.scatter(validate_X['LStat'],pred,color='red',alpha=0.5)
plt.xlabel('LStat')
plt.ylabel('Price')

plt.subplot(4, 2,3)
plt.scatter(validate_X['Rooms'],validate_Y,alpha=0.5)
plt.scatter(validate_X['Rooms'],pred,color='red',alpha=0.5)
plt.xlabel('Rooms')
plt.ylabel('Price')

plt.subplot(4, 2,4)
plt.scatter(validate_X['Distance'],validate_Y,alpha=0.5)
plt.scatter(validate_X['Distance'],pred,color='red',alpha=0.5)
plt.xlabel('Distance')
plt.ylabel('Price')

plt.subplot(4, 2,5)
plt.scatter(validate_X['PTRatio'],validate_Y,alpha=0.5)
plt.scatter(validate_X['PTRatio'],pred,color='red',alpha=0.5)
plt.xlabel('PTRatio')
plt.ylabel('Price')

plt.subplot(4, 2,6)
plt.scatter(validate_X['NOX'],validate_Y,alpha=0.5)
plt.scatter(validate_X['NOX'],pred,color='red',alpha=0.5)
plt.xlabel('NOX')
plt.ylabel('Price')

#plt.subplot(4, 2,7)
#plt.scatter(validate_X['Industrial'],validate_Y,alpha=0.5)
#plt.scatter(validate_X['Industrial'],pred,color='red',alpha=0.5)
#plt.xlabel('Industrial')
#plt.ylabel('Price')

plt.subplot(4, 2,7)
plt.scatter(validate_X['Tax'],validate_Y,label="Actual",alpha=0.5)
plt.scatter(validate_X['Tax'],pred,color='red',label="Predicted",alpha=0.5)
plt.xlabel('Tax')
plt.ylabel('Price')
plt.legend()

#columns=['Crime','Zone','Industrial','River','NOX','Rooms','Age','Distance','Radial','Tax','PTRatio','Blk','LStat']
fi_scaled=[i/sum(lreg.feature_importances_)*100 for i in lreg.feature_importances_]
plt.subplot(4, 2,8)
plt.barh(['Crime','Zone','Industrial','River','NOX','Rooms','Age','Distance','Radial','Tax','PTRatio','Blk','LStat'],fi_scaled)
#print(validate_X.Sort)

plt.show()



