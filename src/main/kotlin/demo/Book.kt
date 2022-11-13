package demo

import javax.persistence.Entity
import javax.persistence.Id

/**
 * 書誌情報を表現します。
 */
@Entity
data class Book(
    @Id
    var id: Long,
    var title: String,
    var subTitle: String,
    var edition: String,
    var author: String,
    var publisher: String,
    var publishedDate: String,
    var isbnCode: String
)
