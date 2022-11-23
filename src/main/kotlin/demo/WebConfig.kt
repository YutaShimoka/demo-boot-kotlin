package demo

import org.springframework.context.annotation.Configuration
import org.springframework.data.domain.PageRequest
import org.springframework.data.web.PageableHandlerMethodArgumentResolver
import org.springframework.web.method.support.HandlerMethodArgumentResolver
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer

@Configuration
class WebConfig : WebMvcConfigurer {

    override fun addArgumentResolvers(argumentResolvers: MutableList<HandlerMethodArgumentResolver?>) {
        val resolver = PageableHandlerMethodArgumentResolver()
        resolver.setFallbackPageable(PageRequest.of(0, 10))
        argumentResolvers.add(resolver)
        super.addArgumentResolvers(argumentResolvers)
    }
}
