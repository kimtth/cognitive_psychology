# 1. ����ġ ���ڷ� ������ �м� ������ �������� ��ȯ�ϱ�

# 2. ����ġ ���ڷῡ ���� ��ó�� �۾� �����ϱ�

## (1) ����ġ ���ڷ� ���� �����ޱ�
# ����� ����ġ ���ڷ� ������ url �ּ� ����ϱ�.
raw <- "https://raw.github.com/cognitivepsychology/cognitive_psychology/master/RawData/RawData.zip"
# ����� ����ġ ���ڷ� ���� �����ޱ�(url�� https�� �����ϴ� ����Ʈ�� ����� �ڷ�� 
# download.file("url", "���ϸ�")���� �������� ���� ���� ����. 
# ���� https ����Ʈ �ڷᵵ �������� �� �ְ� ���ִ� ��Ű�� httr�� �ҷ��� ��.
library(httr)
response <- GET(raw,
                write_disk("raw.zip"),
                progress())
# ����� ����ġ ���ڷ� ������ RawData ������ Ǯ��.
unzip("raw.zip", exdir="RawData")
## (2) ����ġ ���ڷ� ���� �����ϱ�

# ��� ����ġ ���ڷ� ���ϸ��� ���� ��� �ۼ��ϱ�.
whole <- list.files(path = "RawData/", pattern = "*CT*")
# ����ġ ���ڷ� ������ ����� ���丮�� ��ŷ ���丮�� �����ϱ�.
setwd("RawData/")
# �ڷ� ���� �� ������ �����ִ� ��Ű�� plyr �ҷ�����.
library(plyr) 
# ��� �� ��� ����ġ ���ڷ� ������ �ؽ�Ʈ ���� �о���̱�.
list.whole <- llply(whole, readLines)
# ���ϸ��� �� �����鼭 "<"�� ���� �κ��� ""���� �ٲٱ�. 
whole.1 <- llply(list.whole, function(x) gsub("[0-9]CT.*<", "", x)) 
# "<"�� ���� ���ε鸸 �߸���(�ش� ����ġ ���Ͽ� ���� �պκ��� �Ұ��� ����).
whole.2 <- llply(whole.1, function(x) grep("[0-9]CT", x, value=T)) 
# ���� ��ȣ�� ���¼� �м� �±� ���� ������ �����, �±׵� ������ �����.
whole.3 <- llply(whole.2, function(x) gsub("[0-9]CT.*\t.*\t", "", x)) 
# ���� punctuation ��ȣ ����(��, �缱 "/"�� ���ܵ�).
whole.4 <- llply(whole.3, function(x) gsub("[]$*+.?[^{|(\\#%&~_<=>'!,:;`\")}@-]", "", x))
# ����ġ ���ڷ� ���Ͽ� �ݺ������� ��Ÿ���� ���ĺ� "c" ���ֱ�.
whole.5 <- llply(whole.4, function(x) gsub("c", "", x)) 
# ��ȣ�� ��Ÿ���� �±�(/SF, /SP, /SS, /SE, /SO, ./SW) ����.
whole.6 <- llply(whole.5, function(x) gsub("/SF|/SP|/SS|/SE|/SO|/SW", "", x))
# ���� ������ �Ϸ�� 200���� �ڷ� ������ ���� �ϳ��� R �ؽ�Ʈ ���ͷ� �����.
whole.7 <- paste(whole.6, collapse=" ")

# �ؽ�Ʈ ���̴� ��Ű�� stylo �ҷ�����.
library(stylo) 
# �ؽ�Ʈ�� ������ ��(line)���� ����(word)�� �ٲ���.
whole.words <- txt.to.words(whole.7, splitting.rule ="[ \t\n]+", preserve.case = T) 
# ����� punctuation ��ȣ ���ֱ�(��, "/"�� ���ܵ�).
whole.words.1<- gsub("[]$*+.?[^{|(\\#%&~_<=>'!,:;`\")}@-]", "", whole.words) 
# ���� ������ �ڷḦ �� �ܾ� ���� ������ ������.
whole.2gram <- make.ngrams(whole.words.1, ngram.size = 2)
# ���� ������ �ڷḦ �� �ܾ� ����� ������. �̴� ������+�λ��+������ ���⸦ �������� ���� ���� ����.
whole.3gram <- make.ngrams(whole.words.1, ngram.size = 3)

# JKO(������ ���� ǥ��)�� VV(�Ϲݵ���) �Ǵ� JKO�� XSV(�Ļ�����)�� ������ �� �ܾ� ���⸸ �߸���.
whole.2gram.n.v <- grep("JKO[ \t\n]+[^a-zA-Z]+VV|JKO[ \t\n]+.+XSV", whole.2gram, value=T)
# R�� ����� �⺻ �ؽ�Ʈ ���̴� ���ɾ��� grep, gsub�� ����� Ȯ��� �ؽ�Ʈ ���̴� ��Ű�� stringr �ҷ�����.
library(stringr) 
# ���+������ �������/������ ����(�� 286��)�� �տ� ���� ��츸 �����ϱ�.
whole.2gram.n.v <- grep("^+.+/ETN+.+[ \t\n\r\f\v]|^+.+/EF+.+[ \t\n\r\f\v]", whole.2gram.n.v, value = T, invert = T) 
# VV ��� �����, �м��� ���Ǹ� ���� �� �ڿ� ��ħǥ�� ���̱�.
whole.2gram.n.v.root <- str_replace_all(whole.2gram.n.v, c("VV+.+."), "VV.")
# XSV ��� �����, �м��� ���Ǹ� ���� �� �ڿ� ��ħǥ�� ���̱�.
whole.2gram.n.v.root.1 <- str_replace_all(whole.2gram.n.v.root, c("XSV+.+."), "XSV.")  
# �м��� ���Ǹ� ���� "��, ��, ��/JKO"��" "��/JKO"�� �����ϱ�.
whole.2gram.n.v.root.2 <- str_replace_all(whole.2gram.n.v.root.1, "��/JKO", "��/JKO")
whole.2gram.n.v.root.2 <- str_replace_all(whole.2gram.n.v.root.2, "��/JKO", "��/JKO")
# ������ + ������ ���� ��� ����.
whole.2gram.n.v.root.2

# �� �ܾ� ���� �ڷῡ�� ������(JKO) + �λ��[�����(vA)+������/�λ�(MAG)] + ������ ���� ã�Ƴ���.
whole.3gram.n.a.v <- grep("JKO[ \t\n]+[^a-zA-Z]+VA+.+VV|JKO[ \t\n]+[^a-zA-Z]+VA+.+XSV|JKO[ \t\n]+[^a-zA-Z]+MAG+.+VV|JKO[ \t\n]+[^a-zA-Z]+MAG+.+XSV", whole.3gram, value=T) 
# �λ�(MAG)+���� �Ļ� ���̻�(XSV) ���յ� �� �ܾ� ���⸦ ��Ͽ��� �����ϱ�(�� ������ �̹� �� �ܾ� ���� ��Ͽ� ����).
whole.3gram.n.a.v.1 <- gsub("[^a-zA-Z]/MAG+[^a-zA-Z]/XSV", "", whole.3gram.n.a.v)
# �� �ܾ� ���� �ڷῡ�� ��+��+�� ���⸸ �߸���.
whole.3gram.n.a.v.2 <- grep("JKO[ \t\n]+[^a-zA-Z]/VA+.+/VV|JKO[ \t\n]+[^a-zA-Z]/VA+.+/XSV|JKO[ \t\n]+[^a-zA-Z]/MAG+.+/VV|JKO[ \t\n]+[^a-zA-Z]/MAG+.+/XSV", whole.3gram.n.a.v.1, value=T) 
# �λ�(MAG)�� �����Ͽ� ��+��+�� ���⸦ ��+�� ����� �����.
whole.3gram.n.a.v.3 <- str_replace_all(whole.3gram.n.a.v.2, "[^a-zA-Z]/MAG", "")
# �λ��(�����+������)�� �����Ͽ� ��+��+�� ���⸦ ��+�� ����� �����.
whole.3gram.n.a.v.4 <- str_replace_all(whole.3gram.n.a.v.3, "[^a-zA-Z]/VA+.+[ \t\n\r\f\v]", " ")  
# �����̽� �� ���� �� ���� ���̱�.
whole.3gram.n.a.v.4 <- str_replace_all(whole.3gram.n.a.v.4, "  ", " ")
# ���+������ �������/������ ����(�� 12��)�� �տ� ���� ��츸 �����ϱ�.
whole.3gram.n.a.v.5 <- grep("^+.+/ETN+.+[ \t\n\r\f\v]|^+.+/EF+.+[ \t\n\r\f\v]", whole.3gram.n.a.v.4, value =T, invert = T) 
# VV ��� �����, �м��� ���Ǹ� ���� �� �ڿ� ��ħǥ�� ���̱�.
whole.3gram.n.a.v.6 <- str_replace_all(whole.3gram.n.a.v.5, c("VV+.+."), "VV.")
# XSV ��� �����, �м��� ���Ǹ� ���� �� �ڿ� ��ħǥ�� ���̱�.
whole.3gram.n.a.v.7 <- str_replace_all(whole.3gram.n.a.v.6, c("XSV+.+."), "XSV.")  
# "��, ��, ��/JKO"��" "��/JKO"�� �����ϱ�.
whole.3gram.n.a.v.8 <- str_replace_all(whole.3gram.n.a.v.7, "��/JKO", "��/JKO")
whole.3gram.n.a.v.8 <- str_replace_all(whole.3gram.n.a.v.8, "��/JKO", "��/JKO")
# ��+��+�� ����� ����� �߸� ��+�� ���� ��� ����.
whole.3gram.n.a.v.8 

# �� �ܾ� ����� �� �ܾ� ���� ��� ���͸� ���� ���� ��+�� ���� ��� ���� �ϼ��ϱ�.
whole.nv <- append(whole.2gram.n.v.root.2, whole.3gram.n.a.v.8) 
# ������� �� �� ���� ��������(NNP)/����(NNB)/��������(NR)/�����(NP) + ������ ���� ���� ������ �Ϲݸ���(NNG) + ����(VV) ������ �����ϱ�.
whole.nv0 <- grep("NNG+.*��", whole.nv, value = T) 
# �м��� ���ʿ��� "/"(������) ���ֱ�.
whole.nv1 <- str_replace_all(whole.nv0, "[]$*+.?[^{|(\\#%&~_/<=>'!,:;`\")}@-]", "") 
# �Է��� ���Ǹ� ���� ���͸��� ª�� ������ �ٲٱ�.
x <- whole.nv1 
# ������(word1), ������(word2), ��+�� ����(word1+word2)�� �ϳ��� ���� �̷�� ������������ �����.
whole.nv2 <- data.frame(cbind(do.call('rbind', strsplit(x, " ")), x)) 
# �� ������ "word1", "word2", "bigram"���� �ٲٱ�.
colnames(whole.nv2) <- c("word1", "word2", "bigram")

# 3. ������ ����ġ �ڷῡ �м��� ���� ���� ���� ���� �߰��ϱ�

## (1) ������ ����ġ �ڷ� ���� �� �׸� �߰��ϱ�

# ������������ �ڷḦ ���� �����ϰ� ������ �� �ֵ��� �����ִ� ��Ű���� data.table ��Ű�� �ҷ�����.
library(data.table) 
# words & 2-gram �ڷ� whole.nv3�� ���������̺� �������� ��ȯ�ϱ�.
whole.nv2.dt <- data.table(whole.nv2)
# ������(word1), ������(word2), ��+�� ����(bigram), ������(word1) ��, ������(word2) ��, ��+�� ����(bigram) �� ���� ������ ������������ �ϼ��ϱ�.
a <- whole.nv2.dt[, freq.bi := .N, by=bigram] 
b <- whole.nv2.dt[, freq.w1 := .N, by=word1]
c <- whole.nv2.dt[, freq.w2 := .N, by=word2]
d <- data.frame(c)
e <- d[, c(1, 2, 3, 5, 6, 4)] 
# bigram �� ���� "freq"��" "freq.bi"�� �����ϱ�.
colnames(e)[6] <- "freq.bi"
# �м��� ���Ǹ� ���� ������������ �̸��� whole.nv.df�� �����ϱ�.
whole.nv.df <- e 

# �ߺ��Ǵ� �� �����ϱ�.
whole.nv.df.uni <- unique(whole.nv.df)
# �ߺ��ڷ� ���� �� ������ �� ��(N = 19652).
nrow(whole.nv.df)
# �ߺ��ڷ� ���� �� ������ �� ��(N = 9342).
nrow(whole.nv.df.uni) 
# �Է��� ���Ǹ� ���� ������������ �̸� �����ϱ�.
whole.uni <- whole.nv.df.uni 

# ����󵵰� 2ȸ �̻��� �ڷḸ �����, �������� NA(not avaible)�� ó���ϱ�.
test1 <- ifelse(whole.uni$freq.bi > 1, whole.uni$freq.bi, NA) 
whole.uni.test1 <- cbind(whole.uni, test1)
# NA�� �ִ� ��(����� 2ȸ �̸��� ��+�� ����) �����ϱ�.
whole.uni.one <- na.omit(whole.uni.test1) 
# �� ��(�� �ܾ� ������ ��) Ȯ��(N = 2340).
nrow(whole.uni.one)
# bigram���� �ߺ��Ǵ� test1�� �����.
whole.one <- whole.uni.one[, 1:6] 

# o11��(Ư�� ��+�� ���� ��) �����ϱ�.
o11 <- whole.one[, 6] 
# o12��(w1 - o11 ��) �����ϱ�.
o12 <- whole.one[, 4] - whole.one[, 6] 
# o21��(w2 - o11 ��) �����ϱ�.
o21 <- whole.one[, 5] - whole.one[, 6] 
# o22��(��ü ��+�� ���� ������[token] - w1 - w2 + o11 ��) �����ϱ�.
o22 <- nrow(whole.nv.df) - whole.one[, 4] - whole.one[, 5] + whole.one[, 6] 
# o11, o12, o21, o22 ���� �ϳ��� ��ġ��.
whole.one.ct <- cbind(whole.one, o11, o12, o21, o22)
# R1, R2, C1, C2, N �� �����ϱ�.
whole.one.ct.add <- transform(whole.one.ct, r1=o11+o12, r2=o21+o22, c1=o11+o21, c2=o12+o22, n=o11+o12+o21+o22)

# E11, E12, E21, E22 �� �����ϱ�.
whole.one.ct.add1 <- transform(whole.one.ct.add, e11=(r1*c1)/n, e12=(r1*c2)/n, e21=(r2*c1)/n, e22=(r2*c2)/n)
# ����: ��� ���� Ư���� numeric���� �ٲٱ�(ū ���� integer�� ������ ����� ��� integer overflow ������ �Ͼ).
as.numeric(whole.one.ct.add1[, 4])
as.numeric(whole.one.ct.add1[, 5])
as.numeric(whole.one.ct.add1[, 6])
as.numeric(whole.one.ct.add1[, 7])
as.numeric(whole.one.ct.add1[, 8])
as.numeric(whole.one.ct.add1[, 9])
as.numeric(whole.one.ct.add1[, 10])
as.numeric(whole.one.ct.add1[, 11])
as.numeric(whole.one.ct.add1[, 12])
as.numeric(whole.one.ct.add1[, 13])
as.numeric(whole.one.ct.add1[, 14])
as.numeric(whole.one.ct.add1[, 15])
as.numeric(whole.one.ct.add1[, 16])
as.numeric(whole.one.ct.add1[, 17])
as.numeric(whole.one.ct.add1[, 18])
as.numeric(whole.one.ct.add1[, 19])

## (2) AM�� ����ġ �׸� �߰��ϱ�

### 1) ī������ �� ��� �� ����ġ �� �����ϱ�

# R1*R2*C1*C2 ���� Ŀ�� integer overflow �޽����� �� �� �����Ƿ�, R1*R2�� C1*C2�� ������ ����� ��.
whole.one.ct.add.chi <- transform(whole.one.ct.add1, chisq = n * 
                                    (abs(o11*o22-o12*o21) - n/2)^2 / 
                                    (r1*r2)) # r1*r2�� ���� ������.
whole.one.ct.add.chisquare <- transform(whole.one.ct.add.chi, chisquare = chisq / (c1*c2)) # C1*C2�� ���߿� ������.
# R1*R2�� �и�� ����� chisq ���� �����, ��¥ ī������ �������� ���� ī������ �� ���� �����.
whole.one.ct.add.chisq <- whole.one.ct.add.chisquare[names(whole.one.ct.add.chisquare) !="chisq"]
# �м��� ���Ǹ� ���� �� ������ chisq�� �ٲٱ�.
colnames(whole.one.ct.add.chisq)[20] <- "chisq"

# ������ �м��� �ռ� E11, E12, E21, E22�� ���󵵸� ���� Ȯ���ϱ�.
sum(whole.one.ct.add.chisq$e11 < 5) / 2340 # 0.9465812
sum(whole.one.ct.add.chisq$e12 < 5) / 2340 # 0.4235043
sum(whole.one.ct.add.chisq$e21 < 5) / 2340 # 0.06794872
sum(whole.one.ct.add.chisq$e22 < 5) / 2340 # 0

### 2) �α� �쵵�� ��� �� ����ġ �� �����ϱ�

whole.one.ct.add.log <- transform(whole.one.ct.add.chisq,
                                  logl = 2 * (
                                    ifelse(o11>0, o11*log(o11/e11), 0) +
                                      ifelse(o12>0, o12*log(o12/e12), 0) +
                                      ifelse(o21>0, o21*log(o21/e21), 0) +
                                      ifelse(o22>0, o22*log(o22/e22), 0)
                                  )) # log 0�� ���Ұ���. ���� �����󵵰� 0�� ���, �α� �쵵�� ���� 0���� ó��.

### 3) t-�� ��� �� ����ġ �� �����ϱ�

whole.one.ct.add.ttest <- transform(whole.one.ct.add.log, ttest = (o11-e11) / sqrt(o11))

### 4) ��ȣ���� ��� �� ����ġ �� �����ϱ�

whole.one.ct.add.mi <- transform(whole.one.ct.add.ttest, MI = log2(o11/e11))

## (3) ������ ���� ��� �׸� �߰��ϱ�

# �������� ������� ���� ����� ��� ���� R�� �ҷ����̱�.
whole.one.human <- read.csv(file="https://raw.github.com/cognitivepsychology/cognitive_psychology/master/whole.one.human.csv")
# 2340���� TRUE �Ǵ� FALSE�� ������ "human"�̶�� ������ ������ ���� ��� ���� ���� ���ڷ� �����������ӿ� �߰��ϱ�.
human <- whole.one.human$human.eval 
whole.one.am.human <- transform(whole.one.ct.add.mi, human = human)