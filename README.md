# peak-operate
peak overlap, merge

![peak files]()



## **Install**

1. Clone the repository:

    ```bash
    git clone https://github.com/hengbingao/peak-operate
    ```

2. Set the executable permissions:

    ```bash
    cd peak-operate
    chmod +x ./bin/*
    chmod +x ./src/*
    ```

3. Add to environment:

    ```bash
    echo 'export PATH=$PATH:$trash/bin' >> ~/.bashrc
    source ~/.bashrc
    ```
## **Usage**


1. Peak common:

    ```bash
    peak common -i $peaks -o common_peak.bed
    ```

2. Peak merge:

    ```bash
    peak merge -i $peaks -o merge_peak.bed
    ```

