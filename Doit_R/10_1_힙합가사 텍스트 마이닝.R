# java 폴더 경로 설정
dyn.load('/Library/Java/JavaVirtualMachines/jdk1.8.0_162.jdk/Contents/Home/jre/lib/server/libjvm.dylib')

library(rJava)
library(KoNLP)
library(dplyr)
library(stringr) # str_replace_all
library(RColorBrewer)
library(wordcloud)


# 데이터 로드
txt <- readLines("data/hiphop.txt")
head(txt)


# 특수문자 제거
txt <- str_replace_all(txt, "\\W", " ")


# 1. 명사 추출
extractNoun("대한민국의 영토는 한반도와 그 부속도서로 한다")


# 2. 빈도 조회
# 가사에서 명사 추출
nouns <- extractNoun(txt)

# 추출한 명사 list를 문자열 벡터로 변환, 단어별 빈도표 생성
wordcount <- table(unlist(nouns))

# 데이터 프레임으로 변환
df_word <- as.data.frame(wordcount, stringsAsFactors = F)

# 변수명 수정
df_word <- rename(df_word,
                  word = Var1,
                  freq = Freq)


# 3. 자주 사용된 단어 빈도표 만들기
# 두 글자 이상 단어 추출
df_word <- filter(df_word, nchar(word) >= 2)
top_20 <- df_word %>%
    arrange(desc(freq)) %>%
    head(20)



# word cloud
# Dark2 색상 목록에서 8개 색상 추출
pal <- brewer.pal(8, "Dark2")
par(family = "AppleGothic")

# 난수 고정
# wordcloud()는 난수를 이용해 매번 다른 모양의 워드 클라우드를 만들어냄.
# 항상 동일한 워드 클라우드가 생성되도록 난수를 고정
#set.seed(1234)

# 워드 클라우드 만들기
wordcloud(words = df_word$word, # 단어
          freq = df_word$freq,  # 빈도
          min.freq = 2,         # 최소 단어 빈도
          max.words = 200,      # 표현 단어 수
          random.order = F,     # 고빈도 단어 중앙 배치
          rot.per = .1,         # 회전 단어 비율
          scale = c(4, 0.3),    # 단어 크기 범위
          colors = pal)         # 색상 목록
