library(dmetar)
data(TherapyFormatsGeMTC)

TherapyFormatsGeMTC$treat.codes


library(gemtc)
network <- mtc.network(data.re  = TherapyFormatsGeMTC$data,
                       treatments = TherapyFormatsGeMTC$treat.codes)

summary(network)

plot(network, use.description = TRUE) # Use full treatment names


png(filename = "./figures/network.png", width = 3200, height = 2000, res = 300)
plot(network, 
    use.description = TRUE,            # Use full treatment names
    vertex.color = "#6a2007",             # node color
    vertex.label.color = "gray10",     # treatment label color
    vertex.shape = "sphere",           # shape of the node
    vertex.label.family = "Helvetica", # label font
    vertex.size = 15,                  # size of the node
    vertex.label.dist = 3,             # distance label-node center
    vertex.label.cex = 2,              # node label size
    edge.curved = 0.2,                 # edge curvature
    edge.color = "skyblue"             # edge color
)
dev.off()





library(netmeta)
m.netmeta <- netmeta(TE = TE,
                     seTE = seTE,
                     treat1 = treat1,
                     treat2 = treat2,
                     studlab = author,
                     data = TherapyFormats,
                     sm = "SMD",
                     common = FALSE,
                     random = TRUE,
                     reference.group = "cau",
                     details.chkmultiarm = TRUE,
                     sep.trts = " vs ")
summary(m.netmeta)

m.netmeta$trts
treatments

netgraph(m.netmeta, labels = treatments)
