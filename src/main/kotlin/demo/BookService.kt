package demo

import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.stereotype.Service

/**
 * 書誌情報ドメインに対するユースケース処理。
 */
@Service
class BookService(private val repository: BookRepository) {
    fun findAllByOrderByPublishedDateDesc(): List<Book> = repository.findAllByOrderByPublishedDateDesc()

    fun findAllByAuthorOrderByPublishedDateDesc(pageable: Pageable, author: String): Page<Book> =
        repository.findAllByAuthorOrderByPublishedDateDesc(pageable, author)
}
