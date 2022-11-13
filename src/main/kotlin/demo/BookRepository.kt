package demo

import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

/**
 * 書誌情報に関わるRepository。
 */
@Repository
interface BookRepository : JpaRepository<Book, Long> {
    fun findAllByOrderByPublishedDateDesc(): List<Book>
}
