library(tidyverse)
library(readr)

# 准备TERM与基因对应关系信息(第一列是pathway,第二列是gene id)
emapper <- read_delim('input/Aaq.query_seqs.fa.emapper.annotations',
                      "\t", escape_double = FALSE, col_names = FALSE,
                      comment = "#", trim_ws = TRUE) %>%
  dplyr::select(GID = X1,
                KO = X9,
                Pathway = X10)

# 准备基因和其对应的KO号：即保留GID和KO号两列，
# 去掉没有注释出KO号的基因，
# 并将一个基因对应多个KO号的情况转换为一个基因对应一个KO号
library(stringr)
gene2KO <- dplyr::select(emapper, GID, KO) %>%
  separate_rows(KO, sep = ',', convert = F) %>%  # convert = F数据类型不改变
  filter(str_detect(KO, 'ko')) %>%   # 保留以ko开头的行,即去掉没有ko注释的基因
  mutate(KO = str_remove(KO, 'ko:'))  # 去掉字符ko:

write.csv(gene2KO,file = 'output/gene2KO.csv',
          row.names = F,quote = F)

# 准备基因和其对应的KeggPathway
library(stringr)
gene2pathway <- dplyr::select(emapper, GID, Pathway) %>%
  separate_rows(Pathway, sep = ',', convert = F) %>%  # convert = F数据类型不改变
  filter(str_detect(Pathway, 'ko')) %>%   # 保留以ko开头的行
  mutate(Pathway = str_remove(Pathway, 'ko'))  # 去掉字符ko

# pathway2gene <- dplyr::select(emapper, GID, Pathway)
write.csv(gene2pathway,file = 'output/gene2pathway.csv',
          row.names = F,quote = F)



# 准备基因和其对应的GO号
emapper_GO <- read_delim('input/Aaq.query_seqs.fa.emapper.annotations',
                      "\t", escape_double = FALSE, col_names = FALSE,
                      comment = "#", trim_ws = TRUE) %>%
  dplyr::select(GID = X1,
                Gene_Symbol = X6,
                GO = X7,
                KO = X9,
                Pathway = X10,
                OG = X21,
                Gene_Name = X22)

gene_info <- dplyr::select(emapper,  GID, Gene_Symbol, Gene_Name) %>%
  dplyr::filter(!is.na(Gene_Name))


library(stringr)
go2gene <- dplyr::select(emapper_GO, GID, GO) %>%
 separate_rows(GO, sep = ',', convert = F) %>%  # convert = F数据类型不改变
 filter(str_detect(GO, 'GO:'))  %>%   # 保留以ko开头的行
 mutate(GO = str_remove(GO, 'GO:'))
write.csv(go2gene,file = 'output/go2gene.csv',
         row.names = F,quote = F)
