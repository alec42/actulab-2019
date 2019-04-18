### 1) Monter le modèle

dt <- read.csv("Data_test.csv", sep = ";")

glm.fit2 <- glm(iscoop ~ coop + ratio, data = dt, family = binomial)

summary.glm(glm.fit2)


glm.probs <- predict(glm.fit2, type = "response")

glm.probs[1:100]

glm.pred <- ifelse(glm.probs > 0.19, "1", "0")

attach(data_final_glm)
table(glm.pred, iscoop)

mean(glm.pred == iscoop) # 0.9579832 = pourcentage d'efficacité du modèle basé sur un p = 0.19.

### 2) tester le modèle

predict(glm.fit2, newdata=data.frame(ratio1 = c(0.8)), type="response") 
#Alors, avec un ratio1 de 0.8, la probabilité que la coopérative soit une coop = 0.9994632

#Essais 1 à 80%, 0.9326923

# https://www.datacamp.com/community/tutorials/logistic-regression-R

probs <- as.numeric(as.character(combiné_sans_tri[, 2])) > 0.80
final_probs <- probs * 1

table(final_probs, names_order$iscoop)
mean(probs == names_order$iscoop)

# Essais 2 à 80%, 0.9224138

test <- combiné_sans_tri[-24, ]

probs <- (as.numeric(as.character(test[, 2])) > 0.80) * 1 # pour changer les true/false en 1/0 et assigner la prob de passage

results <- names_order[-24, ]


table(probs, results$iscoop)
mean(probs == results$iscoop)

### Résulats du tableau de fréquence à 80% avec les données finales
###    0     1
### 0  74   8
### 1  1    33
### = probabilité de 0.9224138

































