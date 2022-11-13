package demo

import com.fasterxml.jackson.annotation.JsonProperty
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController
import java.time.LocalDate
import java.time.format.DateTimeFormatter

/**
 * 書誌情報に関わるUI要求を処理します。
 */
@RestController
@RequestMapping("/api/book")
class BookController(private val service: BookService) {

    @GetMapping("/books")
    fun getBooks(): List<BookUI> =
        service.findAllByOrderByPublishedDateDesc().map { BookUI.of(it) }
}

/** 書誌情報の表示用Dto  */
data class BookUI(
    var id: Long,
    var title: String? = null,
    @JsonProperty("sub_title")
    var subTitle: String? = null,
    var edition: String? = null,
    var author: String? = null,
    var publisher: String? = null,
    @JsonProperty("published_date")
    var publishedDate: String? = null,
    @JsonProperty("isbn_code")
    var isbnCode: String? = null
) {

    companion object {
        private const val serialVersionUID = 1L

        fun of(book: Book): BookUI =
            BookUI(
                book.id,
                book.title,
                book.subTitle,
                book.edition,
                book.author,
                book.publisher,
                this.dateFormat(book.publishedDate),
                book.isbnCode
            )

        /** yyyy-MM-00をyyyy.MMへ変換します。 */
        private fun dateFormat(srcDateStr: String): String {
            val date =
                LocalDate.parse(srcDateStr.replace("-00$".toRegex(), "-01"), DateTimeFormatter.ofPattern("yyyy-MM-dd"))
            return date.format(DateTimeFormatter.ofPattern("yyyy.MM"))
        }
    }
}
