package demo

import org.springframework.stereotype.Service

/**
 * 書誌情報ドメインに対するユースケース処理。
 */
@Service
class BookService(private val repository: BookRepository) {
    fun findAllByOrderByPublishedDateDesc(): List<Book> = repository.findAllByOrderByPublishedDateDesc()
}
