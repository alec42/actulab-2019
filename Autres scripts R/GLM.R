data <- read.csv2("data_final_glm2.csv", sep = ",")

attach(data)
names(data)
data[,9] <- as.numeric(as.character(data[,9]))

model1 <- glm(iscoop ~ coop + membre + mutuel + ratio1, family = binomial, data = data)

summary(model1)

drop1(model1, test ="Chisq")

model2 <- update(model1, ~. - mutuel)

summary(model2)

drop1(model2, test ="Chisq")

model3 <- update(model2, ~. - mutuel)

summary(model3)

drop1(model3, test = "Chisq")

model4 <- update(model3, ~. - membre)

summary(model4)

hist(I(log(coop)))

x <- rep(0.8, 119)

predict(model3, type = "response")
predict(model2, newdata=data.frame(ratio1 = 0.8, type="response"))

