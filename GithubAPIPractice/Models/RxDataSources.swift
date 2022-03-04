//
//  RxDataSources.swift
//  GithubAPIPractice
//
//  Created by 三浦　一真 on 2022/02/19.
//

import RxDataSources

//ViewModelからdatasourceをViewControllerのtableViewにバインドできていればok
//データをいじるときはviewModelのオブザーバに購読させ、
//そこでデータを加工し、加工したデータをdatasourceにacceptすれば
//tableviewにバインドされているのでデータが反映される流れ。

struct SectionModel{
    var items: [Issue]
}

extension SectionModel: SectionModelType{
    init(original: SectionModel, items: [Issue]) {
        self = original
        self.items = items
    }
}
